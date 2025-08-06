#!/usr/bin/env bash
# If any device is connected, print  plus names; otherwise 
if bluetoothctl info | grep -q "Connected: yes"; then
  ICON=""
  INFO=$(bluetoothctl paired-devices | awk '/Device/ {print $3}' | paste -sd ",")
else
  ICON=""
  INFO="off"
fi
echo "{\"icon\":\"$ICON\",\"info\":\"$INFO\"}"

