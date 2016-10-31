#!/bin/sh

nm-applet --sm-disable &
pnmixer &
feh --bg-scale /home/sam/dotfiles/background/calvin.jpg
xinput --set-prop "KMEPC USB Full Speed Gaming Mouse" "Device Accel Constant Deceleration" 2
