#!/bin/sh
nitrogen --restore &
picom &
redshift-gtk &
nm-applet &
pasystray &
xautolock -time 10 -locker /home/rick/.config/qtile/suspend.sh &

