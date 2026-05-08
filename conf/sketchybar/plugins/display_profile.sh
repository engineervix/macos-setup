#!/usr/bin/env bash
# Apply bar y_offset based on connected displays.
#
# Called on SketchyBar startup and on display_change events.
# AeroSpace outer.top gap is handled per-monitor in aerospace.toml directly —
# no config switching needed here.

# ── Tune these values for your setup ─────────────────────────────────────────
# Keep in sync with aerospace.toml [gaps] outer.top:
#   outer.top = Y_OFFSET + bar_height(30) + breathing_room
#   built-in only:      0 + 30 + 15 = 45  (bar flush with menu bar; needs more breathing room)
#   external/clamshell: 8 + 30 +  4 = 42  (bar floats 8px; visual separation already provided)
EXTERNAL_Y_OFFSET=8   # → outer.top = 42 for external/clamshell
BUILTIN_Y_OFFSET=0    # → outer.top = 45 for built-in only
# ─────────────────────────────────────────────────────────────────────────────

# Use aerospace list-monitors — reliable on Apple Silicon (ioreg backlight class absent).
# "built-in only" = one monitor whose name contains "Built-in".
MONITOR_LIST=$(aerospace list-monitors 2>/dev/null)
DISPLAY_COUNT=$(echo "$MONITOR_LIST" | wc -l | tr -d ' ')
BUILTIN_ACTIVE=$(echo "$MONITOR_LIST" | grep -ci "built-in")

if [ "$BUILTIN_ACTIVE" -gt 0 ] && [ "$DISPLAY_COUNT" -le 1 ]; then
    Y_OFFSET=$BUILTIN_Y_OFFSET
else
    Y_OFFSET=$EXTERNAL_Y_OFFSET
fi

sketchybar --bar y_offset="$Y_OFFSET"
