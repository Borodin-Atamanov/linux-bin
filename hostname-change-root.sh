#!/bin/bash
echo ROOT required! Требуется запуск под ROOT!
set -x
echo "Old hostname is "
cat /etc/hostname; 
truncate --size 0 /etc/hostname; 
sudo cat /var/lib/tor/host/hostname >> /etc/hostname; 
echo "New hostname is "
cat /etc/hostname;

#if you want to change tor username
#sudo su;
#rm -virf /var/lib/tor/host/; 
#/etc/init.d/tor status; /etc/init.d/tor restart; /etc/init.d/tor status;

