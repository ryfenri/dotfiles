#! /usr/bin/env bash

option=$(printf 'search\ncontinue' | fzf --layout reverse --prompt 'Mode: ')

case "$option" in
	search)
		command ani-cli
		;;
	continue)
		command ani-cli -c
		;;
	*)
		;;
esac
