#!/bin/sh

# for keyring
eval $(gnome-keyring-daemon --start)
export GNOME_KEYRING_SOCKET
export GNOME_KEYRING_PID

nm-applet --sm-disable &
pnmixer &
feh --bg-scale /home/sam/dotfiles/background/calvin.jpg
xinput --set-prop "KMEPC USB Full Speed Gaming Mouse" "Device Accel Constant Deceleration" 2

TOUCHPAD="DELL0741:00 06CB:7E7E Touchpad"
xinput --set-prop "$TOUCHPAD" "Synaptics Tap Time" 0
xinput --set-prop "$TOUCHPAD" "Synaptics Palm Detection" 1
xinput --set-prop "$TOUCHPAD" "Synaptics Edge Scrolling" 0 0 0
# xinput --set-prop "$TOUCHPAD" "Synaptics Tap Action" 2 3 0 0 1 3 0

dropbox start &
