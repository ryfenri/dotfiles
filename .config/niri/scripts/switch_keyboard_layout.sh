#!/usr/bin/env sh

icon="${HOME}/.config/niri/icons/keyboard.svg"

niri msg action switch-layout next

layout_name=$(niri msg keyboard-layouts | grep "*" | sed -E "s/.*[0-9]+ (.*)/\1/")

notify-send -a "Keyboard layout" -i "$icon" -t 2000 "$layout_name"
