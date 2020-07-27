#!/bin/sh

cat <<EOF | xmenu | sh &
Shutdown		systemctl poweroff
Reboot			systemctl reboot
Suspend			/home/rick/.config/qtile/suspend.sh
EOF
