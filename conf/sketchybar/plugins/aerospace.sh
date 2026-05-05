#!/usr/bin/env bash
# Highlight the focused AeroSpace workspace in SketchyBar.
# Hides workspaces that have no windows; shows and highlights the focused one.
# Invoked with $1 = workspace id, $FOCUSED_WORKSPACE set by the event trigger.

OCCUPIED=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null)

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        background.drawing=on \
        icon.color=0xffcdd6f4  # Catppuccin text — bright when active
elif echo "$OCCUPIED" | grep -qx "$1"; then
    sketchybar --set "$NAME" \
        drawing=on \
        background.drawing=off \
        icon.color=0xffa6adc8  # Catppuccin subtext0 — dim when inactive
else
    sketchybar --set "$NAME" drawing=off
fi
