#!/usr/bin/env bash

set -e

CHOICE=$(printf "Push\nPull" | wofi --dmenu --width 200 --height 100 --prompt "Sync:" --hide-scroll)

if [ -z "$CHOICE" ]; then
  exit 0
fi

# Temp file for feedback display
STATUS_FILE="/tmp/rclone_sync_status.txt"
echo "Starting sync: $CHOICE" >"$STATUS_FILE"

# Show fake "loading" dialog (can also be replaced with a real progress UI)
(
  wofi --dmenu --width 300 --height 100 \
    --prompt "Syncing $CHOICE..." \
    --hide-scroll \
    < <(echo "Please wait...")
) &

WOFI_PID=$!

# Run the actual rclone sync (block until done)
if [ "$CHOICE" = "Push" ]; then
  rclone sync ~/Sync google_enc: && RESULT=0 || RESULT=1
elif [ "$CHOICE" = "Pull" ]; then
  rclone sync google_enc: ~/Sync && RESULT=0 || RESULT=1
else
  kill "$WOFI_PID"
  exit 1
fi

# Kill the fake loading window
kill "$WOFI_PID"

# Show result
if [ "$RESULT" -eq 0 ]; then
  notify-send "✅ Rclone" "$CHOICE completed successfully"
else
  notify-send -u critical "❌ Rclone" "$CHOICE failed"
fi
