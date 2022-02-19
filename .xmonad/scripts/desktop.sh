#!/bin/sh
xrandr --output eDP1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP1 --off --output DP1-1 --off --output DP1-2 --mode 3440x1440 --pos 1920x0 --rotate normal --output DP1-3 --off --output DP2 --off --output DP3 --off --output DP4 --off --output HDMI1 --off --output VIRTUAL1 --off
pulseaudio -k
pactl load-module module-detect
pactl set-default-sink alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink