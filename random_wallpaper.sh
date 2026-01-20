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
query=$(echo "$query" | tr ' ' '+')

wallpaper_url=$(curl -s "https://wallhaven.cc/api/v1/search?q=${query}&sorting=random&categories=010&purity=${SFW}${SKETCHY}${NSFW}&resolutions=1920x1080&apikey=qtLIxlOdpS5mn95Lma3uh5dOGc2ReYVq" \
	| jq -r '.data[0].path')

wallpaper_name=$(basename "$wallpaper_url")

curl -sL -o $HOME/Pictures/${wallpaper_name} $wallpaper_url

swww img "$HOME/Pictures/${wallpaper_name}" --transition-fps 120 --transition-type grow \
	--transition-duration 1 --transition-pos bottom-right
