#!/bin/sh
gnome-screensaver-command -al &
sleep 1
systemctl suspend &
