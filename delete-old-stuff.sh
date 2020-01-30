#!/bin/bash
#Скрипт удаляет файлы, старше заданного количества дней из заданных директорий
cur_log_file_path="/home/i/bin/logs/delete-old-stuff-last.log";
all_log_file_path="/home/i/bin/logs/delete-old-stuff-all.log";
#Насколько старые файлы будут удалены (количество дней)
how_many_days="+3";

function find_and_delete () {
    #function deletes old files from directory "${1}"
    echo "`date +%Y-%m-%d-%H-%M-%S`: Let's delete old stuff from \"${1}\"";
    #find "${1}" -name '*.*' -mtime +30 -exec rm -v {} \ | tee -a "${cur_log_file_path}"; 
    #mkdir -pv "${1}";
    cd "${1}";
    find "${1}" -mtime ${how_many_days} -type f -exec bash -c "echo \"{}\"; sleep 1.13; rm \"{}\"" \; | tee -a "${cur_log_file_path}"; 
    find "${1}" -empty -type d -exec bash -c "echo DIR=\"{}\"; sleep 0.13; rmdir \"{}\"" \; | tee -a "${cur_log_file_path}"; 
    #find "${1}" -empty -type d -exec bash -c "echo \"{}\"; sleep 0.33; rmdir {}" \; | tee -a "${cur_log_file_path}"; 

    #find "${1}" -mtime ${how_many_days} -type d -exec bash -c "echo \"{}\"; sleep 1.13; rmdir {}" \; | tee -a "${cur_log_file_path}"; 
    #echo "`date +%Y-%m-%d-%H-%M-%S`: Let's start yandex-disk-daemon with timeout ${first_start_timeout_sec} seconds ${exclude_dirs}";
    #timeout --kill-after=9 ${first_start_timeout_sec} yandex-disk start ${exclude_dirs} | tee -a "${log_file_path}"; 
}

function find_and_move () {
    #function deletes old files from directory "${1}"
    echo "`date +%Y-%m-%d-%H-%M-%S`: Let's move old stuff from \"${1}\" to \"${2}\" ";
    #find "${1}" -name '*.*' -mtime +30 -exec rm -v {} \ | tee -a "${cur_log_file_path}"; 
    mkdir -p "${2}";
    cd "${1}";
    find "${1}" -mtime ${how_many_days} -type f -exec bash -c "echo \"{}\"; sleep 1.13; mv -v -t \"${2}\" \"`basename `{}\" +" \; | tee -a "${cur_log_file_path}"; 
    find "${1}" -empty -type d -exec bash -c "echo \"{}\"; sleep 0.13; rmdir {}" \; | tee -a "${cur_log_file_path}"; 
    #find "${1}" -empty -type d -exec bash -c "echo \"{}\"; sleep 0.33; rmdir {}" \; | tee -a "${cur_log_file_path}"; 

    #find "${1}" -mtime ${how_many_days} -type d -exec bash -c "echo \"{}\"; sleep 1.13; rmdir {}" \; | tee -a "${cur_log_file_path}"; 
    #echo "`date +%Y-%m-%d-%H-%M-%S`: Let's start yandex-disk-daemon with timeout ${first_start_timeout_sec} seconds ${exclude_dirs}";
    #timeout --kill-after=9 ${first_start_timeout_sec} yandex-disk start ${exclude_dirs} | tee -a "${log_file_path}"; 
}



find_and_delete "/home/i/.cache/thumbnails";
sleep 2.5;
find_and_delete "/home/i/downloads/";
sleep 2.5;
find_and_delete "/home/i/.cache/chromium/";
sleep 2.5;
find_and_delete "/home/i/.cache/dolphin/";
sleep 2.5;
find_and_delete "/home/i/.cache/mozilla/";
sleep 2.5;
find_and_delete "/home/i/Изображения/";
sleep 2.5;
find_and_delete "/home/i/screencasts/";
sleep 2.5;
find_and_delete "/home/i/screenshots/";
sleep 2.5;
find_and_delete "/home/i/mpv-screenshots/";
sleep 2.5;
find_and_delete "/home/i/.local/share/Trash/";
sleep 2.5;





#Let's check, what something really deleted
if [ -s "${cur_log_file_path}" ]; 
then 
    echo -e "${cur_log_file_path} file exists and is not empty \n"; 
    echo -e "\n\n\n\n`date +%Y-%m-%d-%H-%M-%S`\n" | tee -a "${all_log_file_path}"; 
    cat "${cur_log_file_path}" >> "${all_log_file_path}";
    /usr/bin/notify-send "Удалены ненужные старые файлы" "`cat ${cur_log_file_path}`"
    truncate --size 0 "${cur_log_file_path}";
else 
    echo -e "${cur_log_file_path} file does not exists or empty \n"; 
fi; 

