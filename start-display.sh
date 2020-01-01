#!/bin/bash
. /home/i/.profile;
DISPLAY=:0
export $(dbus-launch)

#Script start visual part of system. Like telegram client, what should run with X-server

#sleep 10;
compton &
#sleep 7;
#sleep 10;
telegram-desktop &
/home/i/bin/minimize-all-windows.sh &
#Caps lock - на первую раскладку, Shift+Caps - на вторую
setxkbmap -option "grp:shift_caps_switch,grp_led:scroll"
/usr/bin/chromium-browser &
/home/i/bin/minimize-all-windows.sh &
/usr/bin/cairo-dock --cairo --locked &
sleep 35;
/home/i/bin/minimize-all-windows.sh &
