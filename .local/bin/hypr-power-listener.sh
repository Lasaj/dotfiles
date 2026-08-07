#!/usr/bin/env bash
# Monitor UPower events and execute power saver on AC/BAT change

# Initial run
~/.local/bin/hypr-power-saver.sh

# Listen for UPower DBus signals
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" 2>/dev/null | \
while read -r line; do
    if echo "$line" | grep -q "Online\|State\|percentage"; then
        ~/.local/bin/hypr-power-saver.sh
    fi
done
