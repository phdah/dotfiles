#!/bin/bash

# Mirrors the CloudConnexa VPN connection state to a sentinel file so
# i3status' "path_exists" module can show a red/green indicator.
SENTINEL="/tmp/openvpn3-connected"

if openvpn3 sessions-list 2>/dev/null | grep -A2 "Config name: CloudConnexa" | grep -q "Client connected"; then
    touch "$SENTINEL"
else
    rm -f "$SENTINEL"
fi
