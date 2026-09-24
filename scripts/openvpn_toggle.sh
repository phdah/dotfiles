#!/bin/bash

# Toggle the CloudConnexa VPN session on/off. Bind to dmenu/i3.
# If connected, disconnects. Otherwise (disconnected, or stuck awaiting
# web auth) it clears any stale session and starts a fresh one, which
# triggers a new browser-based Okta login.
CONFIG="CloudConnexa"
LOG="/tmp/openvpn_toggle.log"

{
    echo "=== $(date) ==="
    echo "PATH=$PATH"
    echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"
    echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
    which openvpn3

    session="$(openvpn3 sessions-list 2>&1)"
    echo "sessions-list output:"
    echo "$session"
    session_block="$(echo "$session" | grep -A2 "Config name: $CONFIG")"

    if echo "$session_block" | grep -q "Client connected"; then
        echo "Action: disconnect"
        openvpn3 session-manage --config "$CONFIG" --disconnect
    else
        if [ -n "$session_block" ]; then
            echo "Action: clear stale session, then start"
            openvpn3 session-manage --config "$CONFIG" --disconnect
        else
            echo "Action: start (no existing session)"
        fi
        openvpn3 session-start --config "$CONFIG"
    fi
} >>"$LOG" 2>&1
