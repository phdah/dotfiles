#!/usr/bin/sh
primary=$(xrandr --query | awk '/ primary/{print $1}')
for i in $(seq 9 -1 1); do
    i3-msg "workspace $i; move workspace to output $primary"
done
