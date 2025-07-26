#!/usr/bin/env bash

FILE="/tmp/pomo_status"

if [[ ! -f "$FILE" ]]; then
  echo '{"text": "🍅", "class": "idle"}'
  exit 0
fi

line=$(<"$FILE")
time="${line%%|*}"   # before '|'
status="${line##*|}" # after '|'

if [[ "$status" == "done" ]]; then
  echo "{\"text\": \"⏳ $time\", \"class\": \"done\"}"
elif [[ "$status" == "active" ]]; then
  echo "{\"text\": \"⏳ $time\", \"class\": \"active\"}"
elif [[ "$status" == "paused" ]]; then
  echo "{\"text\": \"⏸️ $time\", \"class\": \"paused\"}"
else
  echo "{\"text\": \"🍅\", \"class\": \"idle\"}"
fi
