#!/usr/bin/env bash
# Highlight the focused AeroSpace workspace in SketchyBar.
# Invoked with $1 = workspace id, $FOCUSED_WORKSPACE set by the event trigger.

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" \
        background.drawing=on \
        icon.color=0xffcdd6f4  # Catppuccin text — bright when active
else
    sketchybar --set "$NAME" \
        background.drawing=off \
        icon.color=0xffa6adc8  # Catppuccin subtext0 — dim when inactive
fi
