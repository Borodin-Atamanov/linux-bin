#!/bin/bash
#cur_log_file_path="/home/i/bin/logs/fstrim-last.log";
all_log_file_path="/home/i/bin/logs/fstrim-all.log";

echo -e "\n\n\n" >> "${all_log_file_path}" 2>&1
date "+%F-%H-%M-%S" >> "${all_log_file_path}" 2>&1
#>> /home/i/bin/logs/fake-http-server.log 2>&1
/sbin/fstrim -v / >> "${all_log_file_path}" 2>&1
date "+%F-%H-%M-%S" >> "${all_log_file_path}" 2>&1
/sbin/fstrim -v /mnt/backup  >> "${all_log_file_path}" 2>&1
date "+%F-%H-%M-%S" >> "${all_log_file_path}" 2>&1
