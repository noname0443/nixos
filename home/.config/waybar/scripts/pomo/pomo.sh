#!/usr/bin/env bash

STATUS_FILE="/tmp/pomo_status"
PID_FILE="/tmp/pomo_pid"
TIME_FILE="/tmp/pomo_time"
WORK_DURATION=25
BREAK_DURATION=5

function notify() {
  notify-send -u normal "$1" "$2"
}

function reset() {
  [[ -f "$PID_FILE" ]] && kill "$(cat "$PID_FILE")" 2>/dev/null
  rm -f "$STATUS_FILE" "$PID_FILE" "$TIME_FILE"
}

function run_timer() {
  local time_left="$1"
  echo "$time_left" >"$TIME_FILE"

  (
    while ((time_left >= 0)); do
      time_left=$(<"$TIME_FILE")
      printf "%02d:%02d|active\n" $((time_left / 60)) $((time_left % 60)) >"$STATUS_FILE"
      sleep 1
      ((time_left--))
      echo "$time_left" >"$TIME_FILE"
    done

    echo "00:00|done" >"$STATUS_FILE"
    notify "✅ Break Time!" "$BREAK_DURATION minutes"
    rm -f "$PID_FILE"
  ) &

  echo $! >"$PID_FILE"
}

function toggle() {
  if [[ ! -f "$STATUS_FILE" ]]; then
    notify "🍅 Pomodoro Started" "$WORK_DURATION minutes of focus"
    run_timer $((WORK_DURATION * 60))
    return
  fi

  local status=$(cut -d '|' -f 2 <"$STATUS_FILE")
  case "$status" in
  active)
    pause
    ;;
  paused)
    resume
    ;;
  *)
    reset
    ;;
  esac
}

function pause() {
  if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
    sed -i 's/active/paused/' "$STATUS_FILE"
  fi
}

function resume() {
  [[ -f "$TIME_FILE" ]] || return
  local time_left=$(<"$TIME_FILE")
  run_timer "$time_left"
}

case "$1" in
toggle)
  toggle
  ;;
reset)
  reset
  ;;
*)
  echo "Usage: $0 [toggle|reset]"
  ;;
esac
