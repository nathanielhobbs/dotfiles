#!/usr/bin/env bash

# Options
options="⏻ Power Off\n Reboot\n⏾ Suspend\n Hibernate\n Logout"

# Ask user via wofi
choice=$(echo -e "$options" | wofi --dmenu --width 300 --height 250 --prompt "Power Menu")

case "$choice" in
  *Power\ Off*) systemctl poweroff ;;
  *Reboot*) systemctl reboot ;;
  *Suspend*) systemctl suspend ;;
  *Hibernate*) systemctl hibernate ;;
  *Logout*) hyprctl dispatch exit ;;
  *) exit 1 ;;
esac

