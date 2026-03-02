#!/usr/bin/env bash

updates="$(yay -Qu | wc -l)"

if [ ${updates} != 0 ]; then
  echo "{\"text\": \"${updates}\", \"tooltip\": \"Update: ${updates}\"}"
else 
  echo "{\"text\": \"${updates}\", \"tooltip\": \"No updates available\"}"
fi
