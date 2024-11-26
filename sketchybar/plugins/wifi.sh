#!/bin/bash

# Get the current Wi-Fi SSID
WIFI_NAME=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')

# If no Wi-Fi is connected, show "Disconnected"
if [ -z "$WIFI_NAME" ]; then
  WIFI_NAME="Disconnected"
fi

# Update the SketchyBar item
sketchybar --set $NAME label="$WIFI_NAME"
