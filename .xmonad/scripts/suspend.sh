#!/bin/sh
if [ $(grep -r "RUNNING" /proc/asound | wc -l) -eq 0 ]; then
    if [ $(pgrep betterlockscreen | wc -l) -lt 1 ]; then
        betterlockscreen -s dimblur &
    fi
fi
