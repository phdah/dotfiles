#!/usr/bin/sh
# Get current workspace, to restore it later.
current_ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).name')

# Get primary screen
primary=$(xrandr --query | awk '/ primary/{print $1}')
for i in $(seq 9); do
    i3-msg "workspace $i; move workspace to output $primary"
done

i3-msg "workspace number $current_ws"
