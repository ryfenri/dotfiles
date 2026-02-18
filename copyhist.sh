#!/usr/bin/env bash

rofi_dir="${HOME}/.config/rofi"
rofi_theme="style-1"

mapfile -t entries < <(cliphist list)
mapfile -t texts < <(cliphist list | cut -f2)

index=$(printf '%s\n' "${texts[@]}" | rofi -dmenu -p '> ' -theme "${rofi_dir}/${rofi_theme}.rasi" -format i)

if [[ -z "$index" ]]; then
    exit
fi

selection_id=$(echo "${entries[$index]}" | cut -f1)

setsid -f sh -c "cliphist decode '$selection_id' | wl-copy" >/dev/null 2>&1 </dev/null
notify-send -t 2000 'Copied to clipboard'
