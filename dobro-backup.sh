#!/bin/bash
#. /home/i/.profile;
#DISPLAY=:0
#export $(dbus-launch)

#Скрипт делает копию файлов из заданной папки в другую, не удаляет файлы из второй папки, если они пропали в первой. Копирует файлы только если они более новые или изменился их размер.

log_file_path="/home/i/bin/logs/dobro-backup.log";
git_repo_addr="https://github.com/Borodin-Atamanov/linux-bin.git";
mkdir -pv `dirname "${log_file_path}"`
GIT_DIR="/home/i/git-linux-bin-fresh/";
mkdir -pv "${GIT_DIR}" | tee -a "${log_file_path}"

function nowcopy () {
    echo -e "\n\n\n";
    echo "`date +%Y-%m-%d-%H-%M-%S`: copy from ${1} to ${2}"  | tee -a "${log_file_path}"
    #rsync --dry-run
    #rsync --info=progress2 --checksum --progress --recursive --human-readable --verbose --exclude=".git" --exclude=".sync"  "${1}" "${2}" | tee -a "${log_file_path}"
    time cp --no-clobber --archive --link --dereference --recursive --strip-trailing-slashes --verbose "${1}" "${2}";
}

function nowcopy_small_files () {
    echo -e "\n\n\n";
    echo "`date +%Y-%m-%d-%H-%M-%S`: copy smallfiles from ${1} to ${2}"  | tee -a "${log_file_path}"
    #rsync --dry-run
    #rsync --info=progress2 --checksum --progress --recursive --human-readable --verbose --exclude=".git" --exclude=".sync" --max-size=40m  "${1}" "${2}" | tee -a "${log_file_path}"
    time cp --no-clobber --archive --link --dereference --recursive --strip-trailing-slashes --verbose "${1}" "${2}";
}

#Копируем файлы из $1 в $2
nowcopy "/home/i/dobro/" "/home/i/backups/dobro/"
sleep 0.01;

#nowcopy "/home/i/dobro/.bin-source/" "/home/i/bin/"
#Copy all files from github repository
cd "${GIT_DIR}"
git clone --verbose --progress --depth 1 "${git_repo_addr}" "${GIT_DIR}" | tee -a "${log_file_path}"
#cd "${GIT_DIR}linux-bin";
git fetch --all --verbose --progress | tee -a "${log_file_path}"
git reset --hard origin/master | tee -a "${log_file_path}"
git status --verbose | tee -a "${log_file_path}"
nowcopy "${GIT_DIR}" "/home/i/bin/"

sleep 0.01;
#chmod --changes --recursive +x "/home/i/bin/"
#поставить права на файлы в папке /home/i/bin/
find "/home/i/bin/" -maxdepth 1 -type f -exec chmod --changes 0755 {} \;
sleep 0.01;

#backup маленьких файлов
zlo="/home/i/.zlo";
mkdir -pv "${zlo}";
sleep 0.01;
nowcopy_small_files "/home/i/Изображения/" "${zlo}/screen/";
sleep 0.01;
nowcopy "/home/i/downloads/" "${zlo}/downloads/";
sleep 0.01;
nowcopy_small_files "/home/i/screencasts/" "${zlo}/screen/";
sleep 0.01;
nowcopy_small_files "/home/i/screenshots/" "${zlo}/screen/";
sleep 0.01;
nowcopy_small_files "/home/i/mpv-screenshots/" "${zlo}/screen/";
sleep 0.01;


