#!/bin/bash
#Start fake http server on 8080 port
while true; do date "+%F-%H-%M-%S.%N"; 
rndstr=$(base64 /dev/urandom | head -c 1024); 
echo -e "HTTP/1.1 200 OK\nContent-Type: text/plain\n\n$(cat /etc/hostname)\n$RANDOM\n$(date "+%F-%H-%M-%S.%N")\n$rndstr\n\n\n" | timeout 317 nc -l -p 8080 -q 1; 
done;

#Check it:
#timeout 10 wget 127.0.0.1:8080 --quiet --no-verbose -O -


#@reboot sleep 10 && /home/i/bin/fake-http-server-start.sh >> /home/i/bin/logs/fake-http-server.log 2>&1
