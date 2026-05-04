#!/usr/bin/env bash
# Battery indicator with colour-coded icon.
# Catppuccin Mocha: green → yellow → red as charge drops.

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

case "$PERCENTAGE" in
    9[0-9]|100) ICON="" ;;
    [6-8][0-9]) ICON="" ;;
    [3-5][0-9]) ICON="" ;;
    [1-2][0-9]) ICON="" ;;
    *)          ICON="" ;;
esac

[ -n "$CHARGING" ] && ICON=""

# Colour shifts green → yellow → red as battery drops
COLOR=0xffa6e3a1   # Catppuccin green
[ "$PERCENTAGE" -le 30 ] 2>/dev/null && COLOR=0xfff9e2af  # yellow
[ "$PERCENTAGE" -le 15 ] 2>/dev/null && COLOR=0xfff38ba8  # red

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
