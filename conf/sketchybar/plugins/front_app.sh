#!/usr/bin/env bash
# Show the name of the currently focused application.
# Mirrors Waybar's hyprland/window module.

if [ "$SENDER" = "front_app_switched" ]; then
    sketchybar --set "$NAME" label="$INFO"
fi
