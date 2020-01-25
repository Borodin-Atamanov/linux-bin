#!/bin/bash 

WAIT_TIME="0.0015"


ALL_WINDOWS_IDS=`wmctrl -l`

#Set the field separator to new line
#IFS=$'\n'
#for i in "$ALL_WINDOWS_IDS"
for i in {1..100}
do
#echo "Welcome times"
#xdotool getactivewindow windowminimize;
#echo "$i";

#Получаем ID активного окна
WID=$(xdotool getactivewindow)
echo $WID;
#Сворачиваем окно по ID
xdotool windowminimize $WID

sleep $WAIT_TIME;
done;


/usr/bin/notify-send "Вы свернули окна" "$ALL_WINDOWS_IDS"
