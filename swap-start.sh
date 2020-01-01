#!/bin/bash
#Script start using swap, it create swap file after system start
#set -x

function calc() { /usr/bin/awk "BEGIN { print "$*" }"; }
function echowait () { echo; sleep 0.2;}
function myeval () { echo "$@"; sleep 0.1; eval "$@"; echo -e "\n"; }

echo -e "\n\n\n\n\n\n\n\n"
date "+%F-%H-%M-%S";
echo "PATH=${PATH}"
export PATH=$PATH:/bin/:/sbin/:/usr/bin/:/usr/sbin/:/home/i/bin/:
echo "PATH=${PATH}"
echo whereis:
myeval "whereis swapoff swapon mkswap rm chmod free"
echo which:
myeval "which swapoff swapon mkswap rm chmod free"
myeval "export"
swapfile_path="/swapfile";
myeval "cat /proc/swaps"
myeval "$(which swapon) --verbose --show"

#Get memory size:
mem_size_in_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo);
echo "mem_size_in_kb = ${mem_size_in_kb}"

#Calculate new swap size
swap_size_kb=$(calc ${mem_size_in_kb}+1024*1024*3);
echo "swap_size_kb = ${swap_size_kb}"

#TODO Сначала пробовать использовать swap, и только если не получается - удалять файл и пробовать заново

myeval "$(which swapoff) -v ${swapfile_path}"
myeval "$(which free) -k"
myeval "$(which rm) -v ${swapfile_path}"
myeval "$(which swapon) --verbose --show"
myeval "$(which fallocate) -l ${swap_size_kb}K ${swapfile_path}"
myeval "$(which chmod) -v 0600 ${swapfile_path}"
myeval "$(which mkswap) --label swaproot ${swapfile_path}"
myeval "$(which swapon) --verbose --fixpgsz --priority 0 ${swapfile_path}"
myeval "$(which swapon) --verbose --show"
myeval "$(which free) -k"

#swapoff -a
#fallocate -l 300m swapfile
#shred --random-source=/dev/zero --iterations=1 --verbose swapfile

#crontab -l
#@reboot sleep 120 && /home/i/bin/swap-start.sh >> /home/i/bin/logs/swap-start.log 2>&1
