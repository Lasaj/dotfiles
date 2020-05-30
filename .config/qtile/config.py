# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
    Key([mod], "Return", lazy.spawn("gnome-terminal")),

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
    Key([mod, "shift"], "x", 
        lazy.spawn("i3lock -c 000000"),
        lazy.spawn("systemctl suspend")),


    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    # Other launchers
    Key([mod], "d", lazy.spawn("dmenu_run -p 'Run: '")),
    Key([mod], "b", lazy.spawn("firefox")),
    Key([mod], "e", lazy.spawn("pcmanfm")),
    Key([mod], "c", lazy.spawn("clion")),

    # Laptop keys
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("amixer sset Master 2dB+")
    ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("amixer sset Master 2dB-")
    ),
    Key([], "XF86AudioMute",
        lazy.spawn("amixer -D pulse set Master toggle")
    ),

    # backlight controls
    Key([], "XF86MonBrightnessUp", lazy.spawn("light -A 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("light -U 5")),
]

group_names = [("Laptop", {'layout': 'monadtall'}),
               ("Desktop", {'layout': 'monadtall'}),
               ("Email", {'layout': 'monadtall'}),
               ("Code", {'layout': 'monadtall'}),
               ("5", {'layout': 'monadtall'}),
               ("6", {'layout': 'monadtall'}),
               ("7", {'layout': 'monadtall'}),
               ("8", {'layout': 'monadtall'}),
               ("Volume", {'layout': 'monadtall'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    # Switch to another group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        
    # Send current window to another group  
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) 

##### DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": 2,
                "margin": 6,
                "border_focus": "129DCC",
                "border_normal": "1D2330"
                }


##### COLORS #####
#colors = [["#0d1a26", "#132639"], # panel background
#          ["#434758", "#434758"], # background for current screen tab
#          ["#ccf5ff", "#ccf5ff"], # font color for group names
#          ["#cc99ff", "#cc99ff"], # font color for alternate names
#          ["#ff5555", "#ff5555"], # border line color for current tab
#          ["#8d62a9", "#8d62a9"], # border line color for other tab and odd widgets
#          ["#668bd7", "#668bd7"], # color for the even widgets
#          ["#e1acff", "#e1acff"], # window name
#          ["#545869", "#545869"] # seperate
#          ]

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
    layout.Max(),
    layout.MonadTall(**layout_theme),
    layout.Stack(num_stacks=3, **layout_theme)
]

widget_defaults = dict(
    font="ubuntu mono",
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()

def init_widgets():
    widgetList = [
            widget.GroupBox(
                font = "Ubuntu Mono",
                active = colours["fg"],
                inactive = colours["bg3"],
                background = colours["bg"]
                ),
            widget.Prompt(
                foreground = colours["fg"],
                background = colours["bg"]
                ),
            widget.WindowName(
                foreground = colours["fg"],
                background = colours["bg"]
                ),
            widget.Systray(
                foreground = colours["fg"],
                background = colours["bg"]
                ),
            widget.CurrentLayoutIcon(
                custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                foreground = colours["fg"],
                background = colours["bg"],
                scale=0.7
                ),
            widget.Sep(
                foreground=colours["bg3"],
                background=colours["bg"],
                ),
            widget.Net(
                interface ="wlp2s0",
                foreground=colours["fg"],
                background=colours["bg"],
                ),
            widget.Sep(
                foreground=colours["bg"],
                background=colours["bg"],
                ),
            widget.TextBox(
                # CPU
                text=" ",
                foreground=colours["d_blue"],
                background=colours["bg"],
                padding = 0,
                ),
            widget.CPUGraph(
                line_width = 2,
                graph_color = colours["d_blue"],
                foreground=colours["d_blue"],
                background=colours["bg"],
                ),
            widget.Sep(
                foreground=colours["bg"],
                background=colours["bg"],
                ),
            widget.TextBox(
                # RAM
                text=" ",
                foreground=colours["d_purple"],
                background=colours["bg"],
                padding = 0,
                ),
            widget.MemoryGraph(
                line_width = 2,
                graph_color = colours["d_purple"],
                foreground=colours["d_purple"],
                background=colours["bg"],
                ),
            widget.Sep(
                foreground=colours["bg"],
                background=colours["bg"],
                ),
            widget.TextBox(
                # Volume
                text=" ",
                foreground=colours["d_gray"],
                background=colours["bg1"],
                padding = 0,
                ),
            widget.Volume(
                font="Ubuntu Mono Bold",
                foreground = colours["d_gray"],
                background = colours["bg1"]
                ),
            widget.Sep(
                foreground=colours["bg1"],
                background=colours["bg1"],
                ),
            widget.TextBox(
                # Battery
                text=" ",
                foreground=colours["bg"],
                background=colours["bg_gray"],
                padding = 0,
                ),
            widget.Battery(
                charge_char = "",
                discharge_char = "",
                empty_char = "",
                font="Ubuntu Mono Bold",
                foreground = colours["bg"],
                background = colours["bg_gray"]
                ),
            widget.Sep(
                foreground=colours["bg_gray"],
                background=colours["bg_gray"],
                ),
            widget.Clock(
                format='%Y-%m-%d %a %I:%M %p',
                font="Ubuntu Mono Bold",
                foreground = colours["bg"],
                background = colours["bg_orange"]
                ),
            ]
    return widgetList

widgets = [
    widget.GroupBox(),
    widget.Prompt(),
    widget.WindowName(),
    widget.Systray(),
    widget.Volume(),
    widget.Battery(),
    widget.Net(),
    widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
        ]

foo = init_widgets()
foo2 = init_widgets()

screens = [
    Screen(
        top=bar.Bar(
            foo
#            [widget.GroupBox(),
#             widget.Prompt(),
#             widget.WindowName(),
#             widget.Systray(),
#             widget.Volume(),
#             widget.Battery(),
#             widget.Net(),
#             widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
#             ]
            ,
            opacity=0.95, size=20,
            #opacity=0.9,
            #24,
        ),
    ),
    Screen(
        top=bar.Bar(
            foo2
            ,
            24,
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
