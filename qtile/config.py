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

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import hook, layout, bar, widget
import os
import subprocess

mod = 'mod1'
control = 'control'

# xmonad style keybindings
keys = [
    # app launches
    Key([mod, control], 't', lazy.spawn('gnome-terminal --hide-menubar')),
    Key([mod, control], 'f', lazy.spawn('firefox')),
    Key([mod], 'p', lazy.spawn('j4-dmenu-desktop')),
    Key([mod, 'shift'], 'p', lazy.spawn('gmrun')),
    Key([mod, control], 'l', lazy.spawn('gnome-screensaver-command -l')),
    # kill
    Key([mod, 'shift'], 'c', lazy.window.kill()),

    # layout management
    Key([mod], 'space', lazy.next_layout()),
    Key([mod], 'k', lazy.layout.down()),
    Key([mod], 'Tab', lazy.layout.down()),
    Key([mod], 'j', lazy.layout.up()),
    Key([mod, 'shift'], 'Tab', lazy.layout.up()),
    Key([mod], 't', lazy.window.toggle_floating()),
    # Move windows up or down in current stack
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_down()),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_up()),
    # Switch window focus to other pane(s) of stack
    Key([mod], 'space', lazy.layout.next()),
    # Swap panes of split stack
    Key([mod, 'shift'], 'space', lazy.layout.rotate()),

    # restarting qtile
    Key([mod, 'shift'], 'q', lazy.shutdown()),
    Key([mod], 'q', lazy.restart()),
]

groups = [Group(i) for i in '123456789']

for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()))
    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, 'shift'], i.name, lazy.window.togroup(i.name)))

layouts = [
    layout.MonadTall(),
    layout.Stack(),
    layout.Max(),
]

widget_defaults = dict(
    # font='Arial',
    fontsize=16,
    padding=3,
)

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.TextBox(text='CPU:', fontsize=12),
                # cpu uses family of dark orange colors
                widget.CPUGraph(border_color='8b4500', fill_color='cd6600', graph_color='ee7600'),
                widget.TextBox(text='Mem:', fontsize=12),
                widget.MemoryGraph(),
                widget.sep.Sep(),
                widget.GroupBox(fontsize=12),
                widget.WindowName(fontsize=12),
                widget.sep.Sep(),
                widget.Systray(),
                widget.Clock(format='%b %d %I:%M', fontsize=12),
            ],
            26,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front())
]

# Windows that float by default
float_rules = [
    dict(wmclass='gmrun'),
    dict(wmclass='unity-control-center'),
]

group_assignments = {}
group_assignments['Slack'] = '8'
group_assignments['Pithos'] = '9'


@hook.subscribe.client_new
def handle_new_window(window):
    if (window.window.get_wm_type()) == 'dialog' or window.window.get_wm_transient_for():
        window.floating = True
    else:
        type = window.window.get_wm_class()[0]
        if type in group_assignments:
            window.togroup(group_assignments[type])


dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=float_rules, border_normal='#97ffff')
auto_fullscreen = True
focus_on_window_activation = 'smart'

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = 'LG3D'


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])