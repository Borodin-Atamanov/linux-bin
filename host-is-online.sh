#!/bin/bash
. /home/i/.profile;
DISPLAY=:0
export $(dbus-launch)

#Script save to cloud-log, what this host is online

sleep 5;

DIR="/home/i/dobro/online/$(cat /etc/hostname)"
mkdir -pv "${DIR}";
cd "${DIR}";
fname=$(date "+%F-%H-%M-%S");
#(uptime; mount; echo -e "\n\n\n"; ps axv;) >> ${fname};
#gzip --best "${fname}";

while true; do sleep 0.1;
    (date "+%F-%H-%M-%S"; free -mtw; echo; uptime; echo; top -wbn 1 | head -n 6; echo; ) >> ${fname};
    
    /sbin/ifconfig 2>&1 | grep byte | grep --invert-match "packets 0" | tee --append "${fname}";
    echo; >> ${fname};
    #/sbin/ifconfig 2>&1 | tee --append "${fname}";
    #echo; >> ${fname};
    
    date "+%F-%H-%M-%S";
    sleep 817;
done;
