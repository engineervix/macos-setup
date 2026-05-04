#!/usr/bin/env bash
# Clock label — mirrors Waybar format: HH:MM | Weekday DD Mon
sketchybar --set "$NAME" label="$(date '+%H:%M | %a %d %b')"
