#!/bin/sh
if [ $(grep -r "RUNNING" /proc/asound | wc -l) -eq 0 ]; then
    i3lock -c 000000 &
    systemctl suspend &
fi
