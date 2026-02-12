#!/usr/bin/env bash

SFW=1
NSFW=0
SKETCHY=0

case "$1" in
	'--sketchy')
		SKETCHY=1	
		shift
		;;
	'--nsfw')
		NSFW=1
		shift
		;;
	'--only-nsfw')
		NSFW=1
		SFW=0
		SKETCHY=0
		;;
	*)
		;;
esac

read -p "Query: " query
query=$(echo "$query" | tr ' ' '%20')

if [ ! -f random_wallpaper_info.json ]; then
	echo '{}' > random_wallpaper_info.json
fi

seed=$(cat "$HOME/random_wallpaper_info.json" | jq -r '.seed')

wallpaper_url=$(curl -s "https://wallhaven.cc/api/v1/search?q=${query}&sorting=random&categories=010&purity=${SFW}${SKETCHY}${NSFW}&resolutions=1920x1080&seed=${seed}&apikey=${WALLHAVEN_API_KEY}" \
	| jq -r '{path: .data[0].path, seed: .meta.seed}' > "$HOME/random_wallpaper_info.json" \
	&& cat "$HOME/random_wallpaper_info.json" | jq -r '.path')

wallpaper_name=$(basename "$wallpaper_url")
wallpaper_path="$HOME/Pictures/${wallpaper_name}"

curl -sL -o "$wallpaper_path" "$wallpaper_url"

(
	generated_name=$(opencode run 'tell me what character that is and only respond with the character name.  Respond with ONLY the character name without the series and with a format for a file with a unique identifier based on the image.
	format examples:
	ruri_breathing_fire.jpg
	ryo_grass.png
	kessoku_band_sakura.jpg' \
		--model opencode/kimi-k2.5-free --file "$wallpaper_path" 2> /dev/null)

	if [ -n "$generated_name" ] && [ -f "$wallpaper_path" ]; then
		mv "$wallpaper_path" "$HOME/Pictures/${generated_name}"
	fi

) &

swww img "$wallpaper_path" --transition-fps 120 --transition-type grow \
	--transition-duration 1 --transition-pos bottom-right
