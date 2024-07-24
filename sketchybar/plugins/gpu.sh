#!/bin/sh

TOTAL_MEM=64 # Hard coded for now, see https://apple.stackexchange.com/questions/4286/is-there-a-mac-os-x-terminal-version-of-the-free-command-in-linux-systems

GPU=$(top -l 1 | awk "/PhysMem:/ {print int(\$2/$TOTAL_MEM*100)}")
COLOR=0xFFFFFFFF

if [ "$GPU" -gt 100 ]; then
  COLOR=0xFFFF0000
fi

sketchybar --set "$NAME" icon="MEM" label.color=$COLOR label="$GPU%"
