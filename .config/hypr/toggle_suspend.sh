#!/bin/bash
if pgrep -x "hypridle" > /dev/null; then
    killall hypridle
    notify-send -t 3000 "Auto-suspend OFF"
else
    hypridle &
    notify-send -t 3000 "Auto-suspend ON"
fi
