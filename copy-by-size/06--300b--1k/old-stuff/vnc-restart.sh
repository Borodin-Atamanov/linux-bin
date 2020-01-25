#!/bin/bash
. /home/i/.profile;
DISPLAY=:0
export $(dbus-launch)

while true; do date "+%F-%H-%M-%S.%N"; 
x11vnc --noipv6 --noxdamage --loop1357,50  --verbose --rfbport 5900 --usepw --display :0 --scale 0.5x0.5 --xrefresh 10 --ping 9 > /home/i/bin/logs/vnc-working.log 
done;

sleep 4;
/usr/bin/notify-send "x11vnc started" "x11vnc --noxdamage --loop --forever --no6 --verbose --rfbport 5900 --usepw --display :0 --scale 0.5x0.5    --xrefresh 10 --ping 9"


#Запустим vnc-сервер
#@reboot sleep 60 && export DISPLAY=:0 && /home/i/bin/vnc-restart.sh >> /home/i/bin/logs/vnc-start.log 2>&1
