#!/bin/bash
#
# a simple dmenu session script 
#
###

DMENU='dmenu -i -fn -xos4-terminus-medium-r-*--12-*-*-*-*-*-iso10646-1 -nb #282828 -nf #ebdbb2 -sb #d65d0e -sf #282828'
choice=$(echo -e "shutdown\nreboot\nsuspend" | $DMENU)

case "$choice" in
  shutdown) systemctl poweroff & ;;
  reboot) sudo shutdown -r now & ;;
  suspend) systemctl suspend & ;;
esac
