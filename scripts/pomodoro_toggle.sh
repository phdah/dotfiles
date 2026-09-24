#!/bin/bash
# Owns all pomodoro state transitions, shown in the i3status bar via
# pomodoro_wrapper.sh.
#
# Usage:
#   pomodoro_toggle.sh          Manual toggle: start a 25 min work session if
#                                none is running, otherwise stop it. Bind to
#                                a keybinding in i3config.
#   pomodoro_toggle.sh advance  Called by pomodoro_wrapper.sh once the
#                                current session's time is up: work -> break,
#                                break -> stopped.
STATE_FILE="/tmp/pomodoro-state"
WORK_SECONDS=$((25 * 60))
BREAK_SECONDS=$((5 * 60))
ICON="/usr/share/icons/Adwaita/symbolic/status/alarm-symbolic.svg"

notify() {
    notify-send -t 5000 -i "$ICON" "🍅 Pomodoro 🍅" "$1"
}

if [ "$1" = "advance" ]; then
    [ -f "$STATE_FILE" ] || exit 0
    mode=$(cut -d: -f1 "$STATE_FILE")
    if [ "$mode" = "work" ]; then
        end=$(($(date +%s) + BREAK_SECONDS))
        echo "break:$end" >"$STATE_FILE"
        notify "Focus session done. Break time ($((BREAK_SECONDS / 60)) min)."
    else
        rm -f "$STATE_FILE"
        notify "Break's over. Session complete."
    fi
else
    if [ -f "$STATE_FILE" ]; then
        rm -f "$STATE_FILE"
        notify "Stopped."
    else
        end=$(($(date +%s) + WORK_SECONDS))
        echo "work:$end" >"$STATE_FILE"
        notify "Focus session started ($((WORK_SECONDS / 60)) min)."
    fi
fi
