import os
import subprocess
from libqtile import hook
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget

from typing import List  # noqa: F401

mod = "mod4"
myTerm = "gnome-terminal"
myConfig = "/home/rick/.config/qtile/config.py"
myIDE = "intellij-idea-ultimate"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Change size
    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "o", lazy.layout.maximize()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.flip()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    # Switch between monitors
    Key([mod], "comma", lazy.to_screen(0)),
    Key([mod], "period", lazy.to_screen(1)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "w", lazy.window.kill()),

    # Toggle between one and two screens
    Key([mod, "shift"], "m", 
        lazy.spawn("xrandr --output VIRTUAL1 --off --output eDP1 --primary "
                   "--mode 1920x1080 --pos 0x0 --rotate normal --output DP1 "
                   "--off --output DP2-1 --off --output DP2-2 "
                   "--mode 3440x1440 --pos 1920x0 --rotate normal "
                   "--output DP2-3 --off --output DP2 --off"),
        lazy.restart()),
    Key([mod, "shift"], "n", 
        lazy.spawn("xrandr --output VIRTUAL1 --off --output eDP1 "
                   "--mode 1920x1080 --pos 0x0 --rotate normal --output DP1 "
                   "--off --output DP2-1 --off --output DP2-2 --off "
                   "--output DP2-3 --off --output DP2 --off")),
    Key([mod, "shift"], "b", 
        lazy.spawn("nitrogen --restore"),
        lazy.restart()),

    # Suspend
    Key([mod, "control"], "x", 
        lazy.spawn("/home/rick/.config/qtile/toggle_suspend.sh")),
    Key([mod, "shift"], "x", 
        lazy.spawn("/home/rick/.config/qtile/suspend_now.sh")),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    # Other launchers
    Key([mod], "Return", lazy.spawn(myTerm)),
    Key([mod], "d", 
        lazy.spawn("dmenu_run -fn 'ubuntu mono' -nb '#282828' "
                   "-nf '#ebdbb2' -sb '#d65d0e' -sf '#282828' "
                   "-p 'Run: '")),
    Key([mod], "b", lazy.spawn("firefox")),
    Key([mod], "e", lazy.spawn("thunar")),
    Key([mod], "c", lazy.spawn(myIDE)),
    Key([mod, "shift"], "p", lazy.spawn("xfce4-screenshooter")),

    # Laptop keys
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    ),
    Key([], "XF86AudioMute",
        lazy.spawn("amixer -D pulse set Master toggle")
    ),

    # backlight controls
    Key([], "XF86MonBrightnessUp", lazy.spawn("light -A 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("light -U 5")),
]

group_names = [("LTOP", {'layout': 'monadtall'}),
               ("DESK", {'layout': 'monadtall'}),
               ("MAIL", {'layout': 'monadtall'}),
               ("CODE", {'layout': 'monadtall'}),
               ("#5", {'layout': 'monadtall'}),
               ("#6", {'layout': 'monadtall'}),
               ("#7", {'layout': 'monadtall'}),
               ("#8", {'layout': 'monadtall'}),
               ("VOL", {'layout': 'monadtall'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    # Switch to another group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        
    # Send current window to another group  
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) 
    # Send current window to another group and follow it
    keys.append(Key([mod, "control"], str(i), 
        lazy.window.togroup(name),
        lazy.group[name].toscreen())) 

##### DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": 2,
                "margin": 6,
                "border_focus": "129DCC",
                "border_normal": "1D2330"
                }

##### COLORS #####
# gruvbox based
colours = {
        # dull
        "bg" : "#282828",
        "d_red" : "#cc241d",
        "d_green" : "#98971a",
        "d_yellow" : "#d79921",
        "d_blue" : "#458588",
        "d_purple" : "#b16286",
        "d_aqua" : "#689d61",
        "d_gray" : "#a89984",
        # bright
        "b_gray" : "#928374",
        "b_red" : "#fb4934",
        "b_green" : "#b8bb26",
        "b_yellow" : "#fabd2f",
        "b_blue" : "#83a598",
        "b_purple" : "#d3869b",
        "b_aqua" : "#8ec07c",
        "fg" : "#ebdbb2",
        # backgrounds
        "bg0_h" : "#1d2021",
        "bg0" : "#282828",
        "bg0_s" : "#32302f",
        "bg1" : "#3c3836",
        "bg2" : "#504945",
        "bg3" : "#665c54",
        "bg4" : "#7c6f64",
        "bg_gray" : "#928374",
        "bg_orange" : "#d65d0e",
        # foreground
        "fg4" : "#a89984"
        }

##### THE LAYOUTS #####
layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(),
    layout.Columns(num_columns=3, **layout_theme)
]

# Mouse Callbacks
def open_calendar(qtile):
    qtile.cmd_spawn("gnome-calendar")

def shutdown_menu(qtile):
    qtile.cmd_spawn("/home/rick/.config/qtile/xmenu.sh")

def init_widgets():
    widgetList = [
            widget.Image(
                filename = "~/.config/qtile/icons/Qtile.png",
                background = colours["bg3"],
                mouse_callbacks = {'Button1': shutdown_menu}
                ),
            widget.GroupBox(
                font = "Ubuntu Mono",
                fontsize=16,
                rounded = False,
                highlight_method = "block",
                highlight_color = colours["bg1"],
                active = colours["fg"],
                inactive = colours["bg3"],
                background = colours["bg"]
                ),
            widget.Prompt(
                font = "Ubuntu Mono",
                fontsize=14,
                foreground = colours["fg"],
                background = colours["bg"]
                ),
            widget.WindowName(
                fontsize=14,
                foreground = colours["fg"],
                background = colours["bg"]
                ),
            widget.Systray(
                background = colours["bg"]
                ),
            widget.CurrentLayoutIcon(
                fontsize=16,
                custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                foreground = colours["fg"],
                background = colours["bg"],
                scale=0.7
                ),
            widget.Sep(
                fontsize=16,
                foreground=colours["bg3"],
                background=colours["bg"],
                ),
            widget.Net(
                fontsize=16,
                font = "Ubuntu Mono",
                format = "{down} ↓↑ {up}",
                interface ="wlan0",
                foreground=colours["fg"],
                background=colours["bg"],
                ),
            widget.Sep(
                fontsize=16,
                foreground=colours["bg3"],
                background=colours["bg"],
                ),
            widget.TextBox(
                # CPU
                fontsize=16,
                text=" ",
                foreground=colours["d_blue"],
                background=colours["bg"],
                padding = 0,
                ),
            widget.CPUGraph(
                fontsize=16,
                line_width = 2,
                graph_color = colours["d_blue"],
                foreground=colours["d_blue"],
                background=colours["bg"],
                ),
            widget.Sep(
                fontsize=16,
                foreground=colours["bg"],
                background=colours["bg"],
                ),
            widget.TextBox(
                # RAM
                fontsize=16,
                text=" ",
                foreground=colours["d_purple"],
                background=colours["bg"],
                padding = 0,
                ),
            widget.MemoryGraph(
                fontsize=16,
                line_width = 2,
                graph_color = colours["d_purple"],
                foreground=colours["d_purple"],
                background=colours["bg"],
                ),
            widget.Sep(
                fontsize=16,
                foreground=colours["bg"],
                background=colours["bg"],
                ),
            widget.TextBox(
                # Volume
                fontsize=18,
                text=" ",
                foreground=colours["d_gray"],
                background=colours["bg1"],
                padding = 0,
                ),
            widget.Volume(
                fontsize=18,
                font="Ubuntu Mono Bold",
                foreground = colours["d_gray"],
                background = colours["bg1"]
                ),
            widget.Sep(
                fontsize=18,
                foreground=colours["bg1"],
                background=colours["bg1"],
                ),
            widget.TextBox(
                # Battery
                fontsize=18,
                text=" ",
                foreground=colours["bg"],
                background=colours["bg_gray"],
                padding = 0,
                ),
            widget.Battery(
                fontsize=18,
                format = "{char} {percent:2.0%} {hour:d}:{min:02d}",
                charge_char = "",
                discharge_char = "",
                empty_char = "",
                font="Ubuntu Mono Bold",
                foreground = colours["bg"],
                background = colours["bg_gray"]
                ),
            widget.Sep(
                fontsize=18,
                foreground=colours["bg_gray"],
                background=colours["bg_gray"],
                ),
            widget.Clock(
                fontsize=18,
                format='%Y-%m-%d %a %I:%M %p',
                font="Ubuntu Mono Bold",
                foreground = colours["bg"],
                background = colours["bg_orange"],
                mouse_callbacks = {'Button1': open_calendar}
                ),
            ]
    return widgetList

wigdetsScreen1 = init_widgets()
wigdetsScreen2 = init_widgets()
del wigdetsScreen2[4]

screens = [
    Screen(
        top=bar.Bar(
            wigdetsScreen1,
            opacity=0.9, size=24,
        ),
    ),
    Screen(
        top=bar.Bar(
            wigdetsScreen2,
            opacity=0.9, size=24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# Run on startup
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])


dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
