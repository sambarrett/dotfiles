#!/bin/sh

nm-applet --sm-disable &
pnmixer &
feh --bg-scale /home/sam/dotfiles/background/calvin.jpg
xinput --set-prop "KMEPC USB Full Speed Gaming Mouse" "Device Accel Constant Deceleration" 2
xinput --set-prop "DELL0741:00 06CB:7E7E Touchpad" "Synaptics Tap Time" 0

# for keyring
eval $(gnome-keyring-daemon --start)
export GNOME_KEYRING_SOCKET
export GNOME_KEYRING_PID
