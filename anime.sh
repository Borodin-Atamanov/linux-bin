#!/bin/bash
. /home/i/.profile;
DISPLAY=:0
export $(dbus-launch)

#select random duration in seconds
seconds=( "1" "2" "5" "10" "15" "30" "60" "100" )
duration=${seconds[RANDOM % ${#seconds[@]}]}
echo "duration = ${duration}";

#select random person
pers=( "neko" "tora" "dog" "sakura" "tomoyo")
person=${pers[RANDOM % ${#pers[@]}]}
echo "person = ${person}";

#select random speed
speeds=( "7" "10" "13" "15" "17" "20" "22" "25" "30" "50")
speed=${speeds[RANDOM % ${#speeds[@]}]}
echo "speed = ${speed}";

cmd="timeout --kill-after=9 ${duration}  /usr/games/oneko -display ${DISPLAY} -fg black -bg white -speed ${speed} -${person}"
echo "${cmd}";
${cmd}

#exit;
camera-and-screen-capture-now
