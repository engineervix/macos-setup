#!/usr/bin/env bash
# Network indicator — shows WiFi SSID or ethernet status.
# Mirrors Waybar's network module (icon only + tooltip-style label).

# On macOS 15+, both networksetup and ipconfig getsummary redact/misbehave for SSIDs.
# Use networksetup first; if it fails, confirm connection via ifconfig inet address.
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' 'NF>1{print $2}')

if [ -n "$SSID" ] && [[ "$SSID" != *"not associated"* ]] && [[ "$SSID" != *"redacted"* ]]; then
    sketchybar --set "$NAME" icon="" label="$SSID"
elif ifconfig en0 2>/dev/null | grep -q 'inet '; then
    sketchybar --set "$NAME" icon="" label="WiFi"
elif ifconfig en4 2>/dev/null | grep -q 'status: active' || \
     ifconfig en5 2>/dev/null | grep -q 'status: active'; then
    sketchybar --set "$NAME" icon="" label="Ethernet"
else
    sketchybar --set "$NAME" icon="󰖪" label="Off"
fi
