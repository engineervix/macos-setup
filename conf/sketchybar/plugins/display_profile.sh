#!/usr/bin/env bash
# Apply bar y_offset based on connected displays.
#
# Called on SketchyBar startup and on display_change events.
# AeroSpace outer.top gap is handled per-monitor in aerospace.toml directly —
# no config switching needed here.

# ── Tune these values for your setup ─────────────────────────────────────────
# Keep in sync with aerospace.toml [gaps] outer.top:
#   outer.top = [{ monitor."built-in" = BUILTIN_Y_OFFSET+30+10 }, EXTERNAL_Y_OFFSET+30+4]
EXTERNAL_Y_OFFSET=8   # → outer.top = 42 for external/clamshell
BUILTIN_Y_OFFSET=0    # → outer.top = 40 for built-in only
# ─────────────────────────────────────────────────────────────────────────────

DISPLAY_COUNT=$(sketchybar --query displays 2>/dev/null | grep -c '"DirectDisplayID"' || echo 1)
# AppleBacklightDisplay > 0 means the built-in panel is powered on (lid open).
# Zero means clamshell mode — external display only, even though count is 1.
BUILTIN_ACTIVE=$(ioreg -r -c AppleBacklightDisplay 2>/dev/null | grep -c "AppleBacklightDisplay")

if [ "$BUILTIN_ACTIVE" -gt 0 ] && [ "$DISPLAY_COUNT" -le 1 ]; then
    Y_OFFSET=$BUILTIN_Y_OFFSET
else
    Y_OFFSET=$EXTERNAL_Y_OFFSET
fi

sketchybar --bar y_offset="$Y_OFFSET"
