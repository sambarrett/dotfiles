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
import socket


@hook.subscribe.startup
def dbus_register():
    id = os.environ.get('DESKTOP_AUTOSTART_ID')
    if not id:
        return
    subprocess.Popen(['dbus-send',
                      '--session',
                      '--print-reply',
                      '--dest=org.gnome.SessionManager',
                      '/org/gnome/SessionManager',
                      'org.gnome.SessionManager.RegisterClient',
                      'string:qtile',
                      'string:' + id])


configs = {}
configs['default'] = {'battery': False, 'num_screens': 1}
configs['simulcra'] = {'battery': False, 'num_screens': 2}
configs['ubik'] = {'battery': True, 'num_screens': 1}
configs['valis'] = {'battery': False, 'num_screens': 1}

hostname = socket.gethostname()
config = configs[hostname] if hostname in configs else configs['default']

mod = 'mod1'
control = 'control'

# xmonad style keybindings
keys = [
    # layout management
    Key([mod], 'space', lazy.next_layout()),
    Key([mod], 'h', lazy.layout.grow()),
    Key([mod], 'l', lazy.layout.shrink()),
    Key([mod], 'k', lazy.layout.down()),
    Key([mod], 'Tab', lazy.layout.down()),
    Key([mod], 'j', lazy.layout.up()),
    Key([mod, 'shift'], 'Tab', lazy.layout.up()),
    Key([mod], 't', lazy.window.toggle_floating()),
    # Move windows up or down in current stack
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_down()),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_up()),
    Key([mod], 'Return', lazy.layout.swap_left()),
    # Switch window focus to other pane(s) of stack
    # Key([mod], 'space', lazy.layout.next()),
    # Swap panes of split stack
    Key([mod, 'shift'], 'space', lazy.layout.rotate()),

    # switch monitors
    Key([mod], 'comma', lazy.to_screen(0)),
    Key([mod], 'period', lazy.to_screen(1)),

    # restarting qtile
    Key([mod, 'shift'], 'q', lazy.shutdown()),
    Key([mod], 'q', lazy.restart()),

    # app launches
    Key([mod, control], 't', lazy.spawn('gnome-terminal --hide-menubar')),
    Key([mod, control], 'f', lazy.spawn('firefox')),
    Key([mod], 'p', lazy.spawn('j4-dmenu-desktop')),
    Key([mod, 'shift'], 'p', lazy.spawn('gmrun')),
    Key([mod, control], 'l', lazy.spawn('xscreensaver-command -l')),
    # kill
    Key([mod, 'shift'], 'c', lazy.window.kill()),
    # toggle touchpad
    Key([mod, control], 'm', lazy.spawn('toggle-touchpad-scrolling.sh')),
    # Key([mod, control], 'm', lazy.spawn('xterm -e "echo \"%s\"  && bash"' % lazy.mouse)),

    # media control
    # Key(['shift'], 'F3', lazy.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.pithos'
    #     ' /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Prev')),
    # Key(['shift'], 'F4', lazy.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.pithos'
    #     ' /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next')),
    # Key(['shift'], 'F5', lazy.spawn('amixer set Master 4-')),
    # Key(['shift'], 'F6', lazy.spawn('amixer set Master 4+')),
    # Key(['shift'], 'F7', lazy.spawn('amixer -D pulse set Master 1+ toggle')),
    # Key(['shift'], 'F8', lazy.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.pithos'
    #     ' /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause')),
    Key(['shift'], 'F3', lazy.spawn('to_all_media_players org.mpris.MediaPlayer2.Player.Prev')),
    Key(['shift'], 'F4', lazy.spawn('to_all_media_players org.mpris.MediaPlayer2.Player.Next')),
    Key(['shift'], 'F5', lazy.spawn('amixer set Master 4-')),
    Key(['shift'], 'F6', lazy.spawn('amixer set Master 4+')),
    Key(['shift'], 'F7', lazy.spawn('amixer -D pulse set Master 1+ toggle')),
    Key(['shift'], 'F8', lazy.spawn('to_all_media_players org.mpris.MediaPlayer2.Player.PlayPause')),
]

groups = [Group(i) for i in '1234567890[]']

for i in groups:
    if i.name == '[':
        key = 'bracketleft'
    elif i.name == ']':
        key = 'bracketright'
    else:
        key = i.name
    # mod1 + letter of group = switch to group
    keys.append(Key([mod], key, lazy.group[i.name].toscreen()))
    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, 'shift'], key, lazy.window.togroup(i.name)))

layouts = [
    layout.MonadTall(border_normal='#333333'),
    layout.Stack(border_focus='#ff0000', border_normal='#333333'),
    layout.Max(),
]

widget_defaults = dict(
    # font='Arial',
    fontsize=16,
    padding=3,
)


def get_status_bar_elements(conf, is_primary):
    status_bar_elements = []
    status_bar_elements += [
        widget.TextBox(text='CPU:', fontsize=12),
        # cpu uses family of dark orange colors
        widget.CPUGraph(border_color='8b4500', fill_color='cd6600', graph_color='ee7600'),
        widget.TextBox(text='Mem:', fontsize=12),
        widget.MemoryGraph(),
    ]
    if conf['battery']:
        status_bar_elements += [
            widget.TextBox(text='Bat:', fontsize=12),
            widget.Battery(format='{char} {percent:2.0%}'),
        ]
    status_bar_elements += [
        widget.sep.Sep(),
        widget.TextBox(text='Vol:', fontsize=12),
        widget.Volume(),
        widget.sep.Sep(),
        widget.GroupBox(fontsize=12, this_current_screen_border='#FF0000', urgent_border='#00FF00', disable_drag=True),
        widget.WindowName(fontsize=12),
        widget.sep.Sep(),
    ]
    if is_primary:
        status_bar_elements.append(widget.Systray())
    status_bar_elements += [
        widget.Clock(format='%b %d %I:%M', fontsize=12),
    ]
    return status_bar_elements

screens = [Screen(bottom=bar.Bar(get_status_bar_elements(config, i == 0), 26),) for i in range(config['num_screens'])]

def noop(qtile):
    pass

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
    # Drag([], 'Button4', lazy.function(noop), focus=None),
    # Drag([], 'Button5', lazy.function(noop), focus=None)
]

# Windows that float by default
float_rules = [
    dict(wmclass='gmrun'),
    dict(wmclass='unity-control-center'),
    dict(wmclass='gazeb'),
    dict(wmclass='rqt_gui'),
    dict(wmclass='Matplotlib'),
    dict(wmclass='mountain_car_human_controlled.py'),
]

wm_class_to_group = {}
wm_class_to_group['slack'] = '8'
wm_class_to_group['pithos'] = '9'
wm_class_to_group['open.spotify.com'] = '9'


@hook.subscribe.client_new
def handle_new_window(window):
    # with open('/home/sam/temp/qtile.log', 'a') as f:
    #     print('new', window.window.get_wm_type(), window.window.get_wm_class(), window.name, file=f)
    if (window.window.get_wm_type()) == 'dialog' or window.window.get_wm_transient_for():
        window.floating = True
    else:
        wm_class = window.window.get_wm_class()[0]
        if wm_class in wm_class_to_group:
            window.togroup(wm_class_to_group[wm_class])


# @hook.subscribe.client_name_updated
# def handle_name_update(window):
#     with open('/home/sam/temp/qtile.log', 'a') as f:
#         print('updated', window.window.get_wm_type(), window.window.get_wm_class(), window.name, file=f)
#     name = window.name
#     if name in wm_name_to_group:
#         window.togroup(wm_name_to_group[name])


dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=float_rules, border_normal='#97ffff', border_focus='#FF0000')
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
