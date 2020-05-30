#!/bin/sh
nitrogen --restore &
compton &
redshift-gtk &
nm-applet &
pasystray &
xautolock -time 10 -locker /home/rick/.config/qtile/suspend.sh &

