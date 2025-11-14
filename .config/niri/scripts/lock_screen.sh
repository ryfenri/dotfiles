#!/usr/bin/env bash

lock() {
	local cmd=("$@")

	"${cmd[@]}" ipc call lockScreen lock
	"${cmd[@]}" ipc call media stop
}

if command -v noctalia-shell &> /dev/null; then
	lock noctalia-shell
else
	lock qs -c noctalia-shell
fi
