#!/bin/bash

set -euo pipefail

avatar="$HOME/.face"
assets="/usr/share/sddm/themes/pixie/assets"
noctalia_settings="$HOME/.local/state/noctalia/settings.toml"

current_wallpaper=$(tq -r ".wallpaper.default.path" -f "$noctalia_settings")

cp -- "$avatar" "${assets}/avatar.jpg"
cp -- "$current_wallpaper" "${assets}/background.jpg"
