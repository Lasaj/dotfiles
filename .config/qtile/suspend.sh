#!/bin/sh
if [ $(grep -r "RUNNING" /proc/asound | wc -l) -eq 0 ]; then
    gnome-screensaver-command -al &
    sleep 1
    systemctl suspend &
fi
