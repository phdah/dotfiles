#!/bin/sh

CPU=$(top -l 1 | awk '/CPU usage/ {print int($3)}')
COLOR=0xFFFFFFFF

if [ "$CPU" -gt 60 ]; then
  COLOR=0xFFFF0000
fi

sketchybar --set "$NAME" icon="CPU" label.color=$COLOR label="$CPU%"
