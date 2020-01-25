#!/bin/bash
. /home/i/.profile;
DISPLAY=:0
export $(dbus-launch)

#Скрипт выполняется при следующей перезагрузке системы (так должно быть написано в crontab

log_file_path="/home/i/bin/logs/run-on-next-reboot.log";

echo "`date +%Y-%m-%d-%H-%M-%S`: delete this file"  | tee -a "${log_file_path}" 
#rsync --dry-run 
rm -fv "/home/i/bin/run-on-next-reboot.sh"

#Запустим при перезагрузке
#@reboot sleep 10 && /home/i/bin/run-on-next-reboot.sh >> /home/i/bin/logs/last_reboot_action.log 2>&1

