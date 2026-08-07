#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILE="$HOME/Pictures/Screenshots/Screenshot_${TIMESTAMP}.png"

grim -g "$(slurp)" - | tee "$FILE" | wl-copy && \
notify-send "Screenshot Captured" "Saved to ~/Pictures/Screenshots and copied to clipboard"
