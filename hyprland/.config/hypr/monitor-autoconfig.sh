#!/bin/bash

# Detect number of monitors and update config if only one
MONITOR_COUNT=$(hyprctl monitors | grep -c "Monitor")

CONFIG="$HOME/.config/hyprland/hyprland.conf"

if [[ $MONITOR_COUNT -eq 1 && ! -f "$CONFIG.single_monitor_applied" ]]; then
    echo "[*] Single monitor detected. Updating hyprland.conf..."
    
    # Replace all 'monitor=' lines and append default single monitor line
    sed -i '/^monitor=/d' "$CONFIG"
    echo "monitor=,preferred,auto,1" >> "$CONFIG"

    touch "$CONFIG.single_monitor_applied"
fi

