#!/bin/bash
. /home/i/.profile;
DISPLAY=:0
export $(dbus-launch)

maximum_size_in_kb=402000;
plasmaid=$(pidof "/usr/bin/plasmashell")
echo "plasmashell process id =$plasmaid ";
sleep 1;
size_in_kb=$(cat "/proc/$plasmaid/status" | grep RssAnon | grep -o "[0-9]*")
echo "plasmashell memory size $size_in_kb Kb";
sleep 1;
#echo "Process id =$plasmaid Size = $size_in_kb Kb"
if [ "${size_in_kb}" -gt "${maximum_size_in_kb}" ]; then
    printf "maximum_size_in_kb=$maximum_size_in_kb has exceeded.\nKilling the process......"
    kill -9 "$plasmaid"
    echo "Killed the process"
    echo `date` "plasmashell killed. More than $size_in_kb Kb"  >> /home/i/bin/logs/plasmashell.log
else
    echo "maximum_size_in_kb=$maximum_size_in_kb has not yet exceeding"
fi


if pgrep -x "plasmashell" > /dev/null
then
#echo "plasmashell Running"  `date` >> /home/i/bin/logs/plasmashell.log
date > /dev/null
else
mkdir -p "/home/i/bin/logs";
echo `date` "plasmashell Stopped. Let's run it!"  >> /home/i/bin/logs/plasmashell.log
#konsole -e "kstart plasmashell &" &
#konsole -e "date &" &
#kbuildsycoca5 && kquitapp5 plasmashell && kstart5 plasmashell
# sleep 2;
# kstart plasmashell &
# sleep 2;
# /usr/bin/kstart5 plasmashell &
# sleep 2;
#plasmashell &
# sleep 2;
/usr/bin/plasmashell --replace &
sleep 4;
/usr/bin/notify-send "plasmashell restarted" "Memory usage was = $size_in_kb (max = $maximum_size_in_kb)"
fi

