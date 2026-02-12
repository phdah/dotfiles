#!/usr/bin/env sh
set -eu

primary="$(xrandr --query | awk '/ connected primary/ {print $1; exit}')"
if [ -z "$primary" ]; then
  primary="$(xrandr --query | awk '/ connected/ {print $1; exit}')"
fi

[ -z "$primary" ] && exit 0

# Keep the current primary; just ensure outputs are enabled and extended above it.
xrandr --output "$primary" --auto >/dev/null 2>&1 || true

xrandr --query | awk '/ connected/ {print $1}' | while read -r output; do
  [ "$output" = "$primary" ] && continue
  xrandr --output "$output" --auto --above "$primary"
done
