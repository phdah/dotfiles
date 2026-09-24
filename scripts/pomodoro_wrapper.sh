#!/bin/bash
# Wraps i3status' i3bar JSON stream and injects a Pomodoro timer block, read
# from the state file owned by pomodoro_toggle.sh. Purely a renderer: it
# reads state and, once time is up, delegates the actual work -> break ->
# off transition (state writes + notifications) to pomodoro_toggle.sh.
#
# Usage (in i3config's bar block):
#   status_command i3status --config ~/.config/i3/i3status.conf | ~/repos/dotfiles/scripts/pomodoro_wrapper.sh
STATE_FILE="/tmp/pomodoro-state"
WORK_COLOR="#88C0D0"
BREAK_COLOR="#A3BE8C"
TOGGLE_SCRIPT="$(dirname "${BASH_SOURCE[0]}")/pomodoro_toggle.sh"

# Pass the i3bar protocol header (version + opening bracket) straight through.
read -r header
echo "$header"
read -r opening
echo "$opening"

first=1
while IFS= read -r line; do
    # i3bar prefixes every array after the first with a comma; strip it so
    # we can re-add it ourselves after modifying the array.
    line="${line#,}"

    mode=""
    if [ -f "$STATE_FILE" ]; then
        mode=$(cut -d: -f1 "$STATE_FILE")
        end=$(cut -d: -f2 "$STATE_FILE")
        remaining=$((end - $(date +%s)))

        if [ "$remaining" -le 0 ]; then
            "$TOGGLE_SCRIPT" advance
            mode=""
            if [ -f "$STATE_FILE" ]; then
                mode=$(cut -d: -f1 "$STATE_FILE")
                end=$(cut -d: -f2 "$STATE_FILE")
                remaining=$((end - $(date +%s)))
            fi
        fi
    fi

    if [ -n "$mode" ]; then
        mins=$((remaining / 60))
        secs=$((remaining % 60))
        if [ "$mode" = "work" ]; then
            label="🍅 Focus"
            color="$WORK_COLOR"
        else
            label="🍅 Break"
            color="$BREAK_COLOR"
        fi
        text=$(printf "%s %02d:%02d" "$label" "$mins" "$secs")
        line=$(echo "$line" | jq -c --arg text "$text" --arg color "$color" \
            '[{full_text: $text, name: "pomodoro", color: $color}] + .')
    fi

    if [ "$first" -eq 1 ]; then
        echo "$line"
        first=0
    else
        echo ",$line"
    fi
done
