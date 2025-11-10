#!/usr/bin/env sh

# NEEDS NOCTALIA-SHELL TO WORK

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

save_dir="${HOME}/.config/swww"
swww_cache_dir="${save_dir}/.cache"

wallpaper_path=$1
wallpaper_name=$(basename "${wallpaper_path}")

cp -f "${wallpaper_path}" "${swww_cache_dir}/${wallpaper_name}"
ln -fs "${swww_cache_dir}/${wallpaper_name}" "${save_dir}/wall.set"

sleep 0.5

notify-send -a "Wallpaper" -i "$1" -t 2500 "Wallpaper updated"
pkill -10 kitty

cp ~/.github/wallpaper/All/* ~/Pictures/wallpapers
