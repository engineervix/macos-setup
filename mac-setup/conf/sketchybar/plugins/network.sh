#!/usr/bin/env bash
# Network indicator — shows WiFi SSID or ethernet status.
# Mirrors Waybar's network module (icon only + tooltip-style label).

SSID=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' 'NF>1{print $2}')

if [ -n "$SSID" ] && [[ "$SSID" != *"not associated"* ]]; then
    sketchybar --set "$NAME" icon="" label="$SSID"
elif ifconfig en1 2>/dev/null | grep -q 'status: active'; then
    sketchybar --set "$NAME" icon="" label="Ethernet"
else
    sketchybar --set "$NAME" icon="󰖪" label="Off"
fi
