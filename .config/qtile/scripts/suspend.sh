#!/bin/sh
if [ $(grep -r "RUNNING" /proc/asound | wc -l) -eq 0 ]; then
    betterlockscreen -s dimblur &
fi
