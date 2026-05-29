#!/usr/bin/bash

# Cache file location
CACHE_FILE="$HOME/.cache/waybar-weather"

# Ensure cache directory exists
mkdir -p "$(dirname "$CACHE_FILE")"

# Fetch weather silently with connection/total timeouts and retries
weather=$(curl -sfS --connect-timeout 5 --max-time 10 --retry 2 "wttr.in/bne?format=%C+%t" 2>/dev/null | sed 's/+//')

if [ -n "$weather" ]; then
    # Save to cache and print
    echo "$weather" > "$CACHE_FILE"
    echo "$weather"
elif [ -f "$CACHE_FILE" ]; then
    # Return cached data if request failed
    cat "$CACHE_FILE"
else
    echo "Weather: N/A"
fi
