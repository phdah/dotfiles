#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

# Get the space ID from the component name (e.g., space.1 -> 1)
SPACE_ID=$(echo "$NAME" | cut -d'.' -f2)

# Query the space details
SPACE_DETAILS=$(yabai -m query --spaces --space "$SPACE_ID")

# Check if the space is focused (boolen)
HAS_FOCUS=$(echo "$SPACE_DETAILS" | jq '.["has-focus"]')

# Check if the space has windows (int)
WINDOW_COUNT=$(echo "$SPACE_DETAILS" | jq '.windows | length')

# Determine visibility
if [ "$HAS_FOCUS" = "true" ]; then
  # Always show the focused space
  sketchybar --set "$NAME" drawing=on background.drawing="$SELECTED"
elif [ "$WINDOW_COUNT" -eq 0 ]; then
  # Hide the space if it is empty and not focused
  sketchybar --set "$NAME" drawing=off
else
  # Show the space if it is not empty
  sketchybar --set "$NAME" background.drawing="$SELECTED"
fi
