#!/bin/bash
set -x
swapoff -a
rm -v swapfile
fallocate -l 4G swapfile
#fallocate -l 300m swapfile
shred --random-source=/dev/zero --iterations=1 --verbose swapfile
chmod -v 0600 swapfile
mkswap swapfile
swapon -a