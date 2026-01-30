#!/usr/bin/env bash

SOCKET="/tmp/pocketwatch.sock"

send_command() {
  echo "$1" | nc -U -N "$SOCKET" 2>/dev/null
}

format_time() {
  local seconds=$1
  local mins=$((seconds / 60))
  local secs=$((seconds % 60))
  printf "%02d:%02d" "$mins" "$secs"
}

if ! [ -S "$SOCKET" ]; then
  echo '{"text":"","tooltip":"Pocketwatch daemon not running","class":"inactive"}'
  exit 0
fi

status=$(send_command '{"action":"status"}')
is_active=$(echo "$status" | jq -r '.data.active // false')

if [ "$is_active" == "false" ]; then
  echo '{"text":"","tooltip":"No active Timer","class":"inactive"}'
  exit 0
fi

label=$(echo "$status" | jq -r '.data.label')
paused=$(echo "$status" | jq -r '.data.paused')
type=$(echo "$status" | jq -r '.data.type')
duration=$(echo "$status" | jq -r '.data.duration')
elapsed=$(echo "$status" | jq -r '.data.elapsed')
remaining=$(echo "$status" | jq -r '.data.remaining')

if [ "$paused" == "true" ]; then
  icon="󰏤"
  class="paused"
elif [ "$type" == "work" ]; then
  icon="󰣖"
  class="work"
elif [ "$type" == "break" ]; then
  icon=""
  class="break"
else
  icon="󱎫"
  class="custom"
fi

if [ -n "$duration" ] && [ "$duration" -gt 0 ]; then
  time_display=$(format_time "$remaining")
  tooltip="$label - $(format_time "$remaining") remaining"
else
  time_display=$(format_time "$elapsed")
  tooltip="$label - $(format_time "$elapsed") elapsed"
fi

text="$icon $label $time_display"

echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip\",\"class\":\"$class\"}"
