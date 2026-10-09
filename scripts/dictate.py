#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["google-genai"]
# ///
"""Push-to-talk dictation via Gemini on Vertex AI.

First call starts recording from the default mic, second call stops it,
transcribes the audio and pastes the text into the focused window. The paste
goes through the clipboard, whose previous content is restored afterwards.
Bind to keys in i3config.

Modes:
  raw      Verbatim transcription (default).
  rewrite  Restructure what was said into concise, well-formulated text.
  agent    Like rewrite, but the transcript goes to a read-only OpenCode agent
           that can look things up via MCP (e.g. Jira, Confluence) first.
           Needs opencode-dictate.service running.

Clipboard context is opt-in per dictation: `dictate.py context` toggles a flag
(before or during recording) so the clipboard is sent along as context, e.g.
the thread being replied to. The flag resets after one dictation. Notifications
are blue while recording/transcribing, green when the clipboard is included.
In raw mode the context is only used for spelling.

Auth/project come from the environment: GOOGLE_GENAI_USE_VERTEXAI,
GOOGLE_CLOUD_PROJECT, GOOGLE_CLOUD_LOCATION and Application Default
Credentials.

Usage:
  dictate.py [raw|rewrite|agent]             Toggle recording
  dictate.py context                         Toggle clipboard context
  dictate.py [raw|rewrite|agent] FILE.wav    Process FILE.wav and print the text (testing)
"""

import json
import os
import signal
import subprocess
import sys
import time
import urllib.request

from google import genai
from google.genai import types

MODEL = "gemini-3.5-flash"
AUDIO_FILE = "/tmp/dictation.wav"
STATE_FILE = "/tmp/dictation.json"
# Exists while clipboard context is on; holds the id of the "armed" notification.
CONTEXT_FLAG_FILE = "/tmp/dictation.with-clipboard"
PROMPTS = {
    "raw": (
        "Transcribe this audio verbatim, in the language that is spoken. "
        "Output only the transcript text, without quotes, timestamps or commentary. "
        "If there is no speech, output nothing."
    ),
    "rewrite": (
        "The audio is someone dictating text. Rewrite what they say into clear, "
        "concise, well-structured text that captures what they mean: drop filler "
        "words, false starts and repetition, and fix grammar. Keep their intent, "
        "facts and the spoken language; do not add new content. Follow any "
        "instructions they give about format. Output only the final text, "
        "without quotes or commentary. Write it as Markdown: plain prose by "
        "default, and Markdown syntax (lists, **bold**, `code`) only where it "
        "helps. Never use HTML tags. If there is no speech, output nothing."
    ),
}
CONTEXT_PROMPTS = {
    "raw": (
        "\n\nThe following text was copied from the screen; it is NOT part of the "
        "audio. Use it only to spell names and terms correctly when they are "
        "spoken. Transcribe only what is actually said; never output words from "
        "this text that are not spoken:"
    ),
    "rewrite": (
        "\n\nThe following text was copied from the screen, for example a "
        "conversation thread the speaker is replying to. Use it as context "
        "for what the speaker is referring to (terminology, names, subject, "
        "what was asked); the output is still their own words, cleaned up. "
        "Do not repeat the context unless asked:"
    ),
}
MODES = ("raw", "rewrite", "agent")
# `opencode serve` from opencode-dictate.service, running the `dictate` agent
# (~/.config/opencode/agents/dictate.md).
OPENCODE_URL = "http://127.0.0.1:4199"
# Thinking adds seconds of latency and isn't needed for plain transcription.
THINKING = {"raw": "minimal", "rewrite": "low"}
# WM_CLASS substrings of windows that paste with ctrl+shift+v.
TERMINALS = ("kitty", "gnome-terminal", "guake")
# Notification (background, foreground, frame). While recording/transcribing:
# blue, or green when the clipboard is included as context.
COLORS = {
    "normal": ("#2E3440", "#ffffff", "#88C0D0"),
    "blue": ("#88C0D0", "#2E3440", "#88C0D0"),
    "green": ("#A3BE8C", "#2E3440", "#A3BE8C"),
}


def notify(title, message="", timeout_ms=2000, replace_id=None, color="normal"):
    """Show a notification; timeout_ms=0 keeps it until replaced. Returns its id."""
    bg, fg, frame = COLORS[color]
    cmd = [
        "notify-send", "-p", "-t", str(timeout_ms),
        "-h", f"string:bgcolor:{bg}", "-h", f"string:fgcolor:{fg}",
        "-h", f"string:frcolor:{frame}", title, message,
    ]
    if replace_id:
        cmd += ["-r", str(replace_id)]
    out = subprocess.run(cmd, capture_output=True, text=True).stdout.strip()
    return int(out) if out.isdigit() else None


def xclip_out(*args):
    try:
        return subprocess.run(
            ["xclip", "-o", "-selection", "clipboard", *args],
            capture_output=True, timeout=1,
        ).stdout
    except subprocess.TimeoutExpired:
        return b""


def clipboard_text():
    return xclip_out().decode(errors="replace").strip()


def save_clipboard():
    """Current clipboard as (xclip target args, bytes), or None if empty."""
    targets = xclip_out("-t", "TARGETS").decode(errors="replace").split()
    if "image/png" in targets:
        return ["-t", "image/png"], xclip_out("-t", "image/png")
    if targets:
        return [], xclip_out()
    return None


def set_clipboard(data, target_args=()):
    subprocess.run(["xclip", "-selection", "clipboard", *target_args], input=data)


def context_on():
    return os.path.exists(CONTEXT_FLAG_FILE)


def context_detail():
    if not context_on():
        return ""
    clip = clipboard_text()
    if not clip:
        return "\nWith clipboard: (empty)"
    return f"\nWith clipboard ({len(clip)} chars): {' '.join(clip.split())[:60]}..."


def show_recording(mode, nid):
    return notify(
        f"Dictation: {mode}", "Recording... press again to stop" + context_detail(),
        0, nid, "green" if context_on() else "blue",
    )


def toggle_context():
    if context_on():
        with open(CONTEXT_FLAG_FILE) as f:
            armed_nid = f.read().strip()
        os.remove(CONTEXT_FLAG_FILE)
    else:
        armed_nid = None
        open(CONTEXT_FLAG_FILE, "w").close()
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE) as f:
            state = json.load(f)
        show_recording(state["mode"], state["nid"])
    elif context_on():
        # Stays up until the next dictation replaces it.
        nid = notify("Dictation", "Next dictation includes the clipboard" + context_detail(), 0, color="green")
        with open(CONTEXT_FLAG_FILE, "w") as f:
            f.write(str(nid or ""))
    else:
        notify("Dictation", "Clipboard context off", 1000, armed_nid)


def process(path, mode, context="", progress=lambda message: None):
    if mode != "agent":
        return gemini(path, mode, context)
    # Spelling hints help the transcript; the agent gets the full context.
    transcript = gemini(path, "raw", context)
    if not transcript:
        return ""
    progress("Asking OpenCode agent...")
    return ask_opencode(transcript, context)


def ask_opencode(transcript, context):
    """Send the dictation to the read-only `dictate` agent on the OpenCode server."""

    def call(method, path, body=None):
        req = urllib.request.Request(
            OPENCODE_URL + path, method=method,
            data=json.dumps(body).encode() if body is not None else None,
            headers={"Content-Type": "application/json"},
        )
        with urllib.request.urlopen(req, timeout=180) as r:
            raw = r.read()
            return json.loads(raw) if raw else None

    message = f"<transcript>\n{transcript}\n</transcript>"
    if context:
        message += f"\n<context>\n{context}\n</context>"
    session = call("POST", "/session", {"title": "dictate"})["id"]
    try:
        reply = call("POST", f"/session/{session}/message", {
            "agent": "dictate", "parts": [{"type": "text", "text": message}],
        })
    finally:
        call("DELETE", f"/session/{session}")
    return "".join(p.get("text", "") for p in reply["parts"] if p["type"] == "text").strip()


def gemini(path, mode, context=""):
    with open(path, "rb") as f:
        audio = f.read()
    prompt = PROMPTS[mode]
    if context:
        prompt += CONTEXT_PROMPTS[mode] + "\n<context>\n" + context + "\n</context>"
    client = genai.Client()
    response = client.models.generate_content(
        model=MODEL,
        contents=[types.Part.from_bytes(data=audio, mime_type="audio/wav"), prompt],
        config=types.GenerateContentConfig(
            thinking_config=types.ThinkingConfig(thinking_level=THINKING[mode])
        ),
    )
    return (response.text or "").strip()


def take_context():
    """Clipboard text if the context flag is on; the flag lasts one dictation."""
    if not context_on():
        return ""
    os.remove(CONTEXT_FLAG_FILE)
    return clipboard_text()


def start_recording(mode):
    armed_nid = None
    if context_on():
        with open(CONTEXT_FLAG_FILE) as f:
            armed_nid = f.read().strip() or None
    proc = subprocess.Popen(
        ["arecord", "-q", "-f", "S16_LE", "-r", "16000", "-c", "1", AUDIO_FILE]
    )
    nid = show_recording(mode, armed_nid)
    with open(STATE_FILE, "w") as f:
        json.dump({"pid": proc.pid, "mode": mode, "nid": nid}, f)


def stop_recording(pid):
    try:
        os.kill(pid, signal.SIGINT)
        # arecord finalises the WAV header on exit; wait for it.
        while os.path.exists(f"/proc/{pid}"):
            time.sleep(0.05)
    except ProcessLookupError:
        pass


def paste(text):
    """Paste via the clipboard, then put the previous clipboard content back."""
    saved = save_clipboard()
    set_clipboard(text.encode())
    # Paste rather than type: newlines don't submit in chat apps, and editors
    # don't auto-continue lists on top of the model's own list markers.
    window = subprocess.run(
        ["sh", "-c", "xprop -id $(xdotool getactivewindow) WM_CLASS"],
        capture_output=True, text=True,
    ).stdout.lower()
    terminal = any(t in window for t in TERMINALS)
    subprocess.run(["xdotool", "key", "--clearmodifiers", "ctrl+shift+v" if terminal else "ctrl+v"])
    # The app fetches the clipboard asynchronously after the keypress.
    time.sleep(0.5)
    if saved:
        set_clipboard(saved[1], saved[0])
    else:
        set_clipboard(b"")


def stop_and_insert():
    with open(STATE_FILE) as f:
        state = json.load(f)
    os.remove(STATE_FILE)
    stop_recording(state["pid"])
    mode, nid = state["mode"], state["nid"]
    context = take_context()
    color = "green" if context else "blue"
    nid = notify(f"Dictation: {mode}", "Transcribing...", 0, nid, color)
    try:
        text = process(
            AUDIO_FILE, mode, context,
            lambda message: notify(f"Dictation: {mode}", message, 0, nid, color),
        )
    except Exception as e:
        notify("Dictation error", str(e), 5000, nid)
        return
    finally:
        if os.path.exists(AUDIO_FILE):
            os.remove(AUDIO_FILE)
    if not text:
        notify(f"Dictation: {mode}", "No speech recognized", 2000, nid)
        return
    notify(f"Dictation: {mode}", "Done", 1, nid)
    paste(text)


if __name__ == "__main__":
    args = sys.argv[1:]
    if args == ["context"]:
        toggle_context()
        sys.exit()
    mode = args.pop(0) if args and args[0] in MODES else "raw"
    if args:
        print(process(args[0], mode, take_context()))
    elif os.path.exists(STATE_FILE):
        stop_and_insert()
    else:
        start_recording(mode)
