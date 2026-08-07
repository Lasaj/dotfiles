#!/usr/bin/env bash

# Directory containing wallpapers
WALLPAPER_DIR="/home/rick/Pictures/Wallpaper"

# Find a random image (jpg, png, jpeg, webp) in the directory
RANDOM_WALL=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n 1)

if [ -n "$RANDOM_WALL" ]; then
    # Write the hyprpaper config file using block syntax
    cat <<EOF > "$HOME/.config/hypr/hyprpaper.conf"
ipc = on
splash = false

wallpaper {
    monitor =
    path = $RANDOM_WALL
    fit_mode = cover
}
EOF

    # Restart hyprpaper to apply the new wallpaper
    killall hyprpaper 2>/dev/null
    hyprpaper >/home/rick/hyprpaper.log 2>&1 &
fi
