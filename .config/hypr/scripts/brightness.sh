#!/usr/bin/env sh

icons_dir="${HOME}/.config/hypr/scripts/icons/volume"


notify_brightness() {
	percentage="$(brightnessctl i | grep -oE '[0-9]+%' | tr -d %)"
	icon="${icons_dir}/vol-${percentage}.svg" 

	notify-send -t 2000 -i "${icon}" "${percentage}"
}


case "$1" in
  -i)
    brightnessctl set +5%
	notify_brightness
    ;;
  -d)
    brightnessctl set 5%-
    notify_brightness
    ;;
  *)
    echo "$0" commands:
    echo 
    echo "-i : increase the brightness"
    echo "-d : decrease the brightness"
    ;;
esac
