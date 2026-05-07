#!/usr/bin/env bash
# Apply bar y_offset and switch AeroSpace config based on connected displays.
#
# Called on SketchyBar startup and on display_change events.
# display_change fires on both monitor hotplug/unplug AND active-display focus
# switches in extended desktop mode — so we guard against needless AeroSpace
# reloads by only switching configs when the target actually changes.
#
# Extended desktop: when any external monitor is connected, the external profile
# is used for all displays (external is primary; built-in is secondary).

# ── Tune these values for your setup ─────────────────────────────────────────
# Keep outer.top in the matching aerospace*.toml in sync:
#   outer.top = y_offset + bar_height(30) + breathing_room
EXTERNAL_Y_OFFSET=8   # aerospace.toml:         outer.top=42  (8+30+4)
BUILTIN_Y_OFFSET=0    # aerospace-builtin.toml: outer.top=40  (0+30+10)
# ─────────────────────────────────────────────────────────────────────────────

# CONFIG_DIR is set by SketchyBar (points to ~/.config/sketchybar, a symlink)
# shellcheck disable=SC2153
CONF_DIR="$(dirname "$(realpath "${CONFIG_DIR}")")"

DISPLAY_COUNT=$(sketchybar --query displays 2>/dev/null | grep -c '"DirectDisplayID"' || echo 1)

if [ "$DISPLAY_COUNT" -gt 1 ]; then
    Y_OFFSET=$EXTERNAL_Y_OFFSET
    AEROSPACE_CONF="$CONF_DIR/aerospace.toml"
else
    Y_OFFSET=$BUILTIN_Y_OFFSET
    AEROSPACE_CONF="$CONF_DIR/aerospace-builtin.toml"
fi

sketchybar --bar y_offset="$Y_OFFSET"

# Only switch and reload AeroSpace when the config target actually changes.
# This avoids disruptive reloads on every display focus switch in extended mode.
CURRENT_CONF=$(readlink "$HOME/.aerospace.toml" 2>/dev/null)
if [ "$CURRENT_CONF" != "$AEROSPACE_CONF" ] && [ -f "$AEROSPACE_CONF" ]; then
    ln -sf "$AEROSPACE_CONF" "$HOME/.aerospace.toml"
    aerospace reload-config 2>/dev/null || true
fi
