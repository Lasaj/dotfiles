#!/usr/bin/env bash
# Hyprland Dynamic Power Saver Script with Desktop Notifications

STATE_FILE="/tmp/hypr_power_state"
LAST_STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "unknown")

# Detect AC power status (1 = AC plugged in, 0 = Battery)
AC_STATE=$(cat /sys/class/power_supply/AC*/online 2>/dev/null || cat /sys/class/power_supply/ADP*/online 2>/dev/null || echo 0)

if [ "$AC_STATE" = "0" ]; then
    # ON BATTERY
    # 1. Disable heavy compositor effects (blur and shadows)
    hyprctl eval "hl.config({ decoration = { blur = { enabled = false }, shadow = { enabled = false } } })" >/dev/null 2>&1

    # 2. Cap brightness to 40% if higher
    CURR_BRIGHT=$(brightnessctl g 2>/dev/null || echo 100)
    MAX_BRIGHT=$(brightnessctl m 2>/dev/null || echo 100)
    PERCENT=$(( CURR_BRIGHT * 100 / MAX_BRIGHT ))
    if [ "$PERCENT" -gt 40 ]; then
        brightnessctl s 40% >/dev/null 2>&1
    fi

    # 3. Apply CPU power preference if writable
    for epp in /sys/devices/system/cpu/cpu*/power/energy_performance_preference; do
        [ -w "$epp" ] && echo "power" > "$epp" 2>/dev/null
    done

    # 4. Apply ThinkPad platform profile to low-power if writable
    if [ -w /sys/firmware/acpi/platform_profile ]; then
        echo "low-power" > /sys/firmware/acpi/platform_profile 2>/dev/null
    fi

    # 5. Enable workqueue power efficiency if writable
    if [ -w /sys/module/workqueue/parameters/power_efficient ]; then
        echo "Y" > /sys/module/workqueue/parameters/power_efficient 2>/dev/null
    fi

    # Send notification on state transition
    if [ "$LAST_STATE" != "BAT" ]; then
        notify-send -u low -i battery-caution "Power Mode: Battery Saver" "Compositor blur disabled • CPU set to low-power"
        echo "BAT" > "$STATE_FILE"
    fi
else
    # ON AC POWER
    # 1. Restore Hyprland blur effects
    hyprctl eval "hl.config({ decoration = { blur = { enabled = true, passes = 1, size = 4 } } })" >/dev/null 2>&1

    # 2. Restore CPU energy performance preference
    for epp in /sys/devices/system/cpu/cpu*/power/energy_performance_preference; do
        [ -w "$epp" ] && echo "balance_performance" > "$epp" 2>/dev/null
    done

    # 3. Restore ThinkPad platform profile to balanced
    if [ -w /sys/firmware/acpi/platform_profile ]; then
        echo "balanced" > /sys/firmware/acpi/platform_profile 2>/dev/null
    fi

    # Send notification on state transition
    if [ "$LAST_STATE" != "AC" ]; then
        notify-send -u low -i battery-charging "Power Mode: AC Performance" "Compositor blur & CPU performance restored"
        echo "AC" > "$STATE_FILE"
    fi
fi
