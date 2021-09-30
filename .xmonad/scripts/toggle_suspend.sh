#!/bin/sh
if [ $(pgrep xautolock | wc -l) -eq 0 ]; 
then
    xautolock -time 10 -locker /home/rick/.config/qtile/scripts/suspend.sh &
    notify-send -t 3000 Suspend ON &
else
    killall xautolock
    notify-send -t 3000 Suspend OFF &
fi
