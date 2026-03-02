#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

while true; do
	selected_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | fzf \
		-d '/' \
		--with-nth -1 \
		--preview 'kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}' \
		--preview-window 'right:50%:wrap' \
		--layout reverse \
		--border rounded \
		--prompt "Wallpaper: " \
		--bind 'ctrl-d:page-down' \
		--bind 'ctrl-u:page-up')

	if [[ -z "$selected_wallpaper" ]]; then
		echo "New wallpaper wasn't selected"
		exit
	fi

	swww img "$selected_wallpaper" --transition-fps 120 --transition-type grow \
	--transition-duration 1 --transition-pos bottom-right

	notify-send "Applied: $(basename "$selected_wallpaper")"
done
