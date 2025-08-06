#!/bin/bash
chosen=$(echo -e "Shutdown\nReboot\nSuspend\nHibernate\nLogout" | rofi -dmenu -p "Power")

case "$chosen" in
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
  Hibernate) systemctl hibernate ;;
  Logout) hyprctl dispatch exit ;;
esac

