#!/usr/bin/env bash

SFW=1
NSFW=0
SKETCHY=0
PREVIEW=false
DOWNLOAD_PREVIEW=false
TAGS=""
QUERY=""

wallpapers_folder="$HOME/Pictures/temp_wallpapers"

function rename_wallpaper() {
	local path="$1"
	local query="$(echo "$2" | tr '%' ' ')"

	local generated_name=$(opencode run "The character/s are from: ${query}
	
	tell me who the character is and only respond with the character name.  Respond with ONLY the character name without the series and with a format for a file with a unique identifier based on the image.

	format examples:
	ruri_breathing_fire.jpg
	ryo_grass.png
	kessoku_band_sakura.jpg

	DON'T include in the filename more than one character.
	if there are more characters that you think is a good idea adding, make a group.
	
	Example for bocchi the rock:
	ryo yamada, hitori gotoh, nijika ijichi, kita ikuyo
	they will make the kessoku band group.  So the filename would be kessoku_band_sakura.png." \
		--model google/gemini-2.5-pro --file "$path" 2> /dev/null)

	if [ -n "$generated_name" ] && [ -f "$path" ]; then
		mv "$path" "$HOME/Pictures/temp_wallpapers/${generated_name}"
	fi
}

while [ "$#" -gt 0 ]; do
	case "$1" in
		--query=*)
			QUERY="${1#--query=}"
			QUERY=$(echo "$QUERY" | tr ' ' '%20')
			shift
			;;
		--tags=*)
			TAGS="${1#--tags=}"
			shift
			;;
		--sketchy)
			SKETCHY=1	
			shift
			;;
		--nsfw)
			NSFW=1
			shift
			;;
		--only-nsfw)
			NSFW=1
			SFW=0
			SKETCHY=0
			shift
			;;
		--preview|-p)
			PREVIEW=true
			shift
			;;
		--download-preview|-dp)
			DOWNLOAD_PREVIEW=true
			shift
			;;
		*)
			;;
	esac
done

if [ "$DOWNLOAD_PREVIEW" = true ]; then
	preview="$(jq -r '.preview' "$HOME/random_wallpaper_info.json")"
	preview_path="$(basename "$preview")"
	curl -sL -o "${wallpapers_folder}/${preview_path}" "$preview"
	exit
fi

if [ -z "$QUERY" ]; then
	read -p "Query: " QUERY
	QUERY=$(echo "$QUERY" | tr ' ' '%20')
fi

if [ ! -f random_wallpaper_info.json ]; then
	echo '{}' > random_wallpaper_info.json
fi

seed=$(cat "$HOME/random_wallpaper_info.json" | jq -r '.seed')

wallpaper_url=$(curl -s "https://wallhaven.cc/api/v1/search?q=${QUERY}%20${TAGS}&sorting=random&categories=010&purity=${SFW}${SKETCHY}${NSFW}&atleast=1920x1080&ratios=16x9&seed=${seed}&apikey=${WALLHAVEN_API_KEY}" \
	| jq -r '{path: .data[0].path, seed: .meta.seed}' > "$HOME/random_wallpaper_info.json" \
	&& cat "$HOME/random_wallpaper_info.json" | jq -r '.path')


wallpaper_name=$(basename "$wallpaper_url")
wallpaper_path="${wallpapers_folder}/${wallpaper_name}"

if [ "$PREVIEW" = true ]; then
	curl -sL -o "/tmp/${wallpaper_name}" "$wallpaper_url" && \
	command swappy -f "/tmp/${wallpaper_name}"

	jq --arg preview "$wallpaper_url" '.preview = $preview' "$HOME/random_wallpaper_info.json" > "/tmp/random-tmp.json" && mv "/tmp/random-tmp.json" "$HOME/random_wallpaper_info.json"
	exit
fi

if [[ ! -d "$wallpapers_folder" ]]; then
	mkdir -p "$wallpapers_folder"
fi

curl -sL -o "$wallpaper_path" "$wallpaper_url"

# temporary disabled because i don't have models that visualize images
# rename_wallpaper "$wallpaper_path" "$query" &  

swww img "$wallpaper_path" --transition-fps 120 --transition-type grow \
	--transition-duration 1 --transition-pos bottom-right
