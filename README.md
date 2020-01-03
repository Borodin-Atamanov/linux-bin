# Some bash scripts for my linux machines

## 4kjpeg
Converts all images to 3840x2160 with ImageMagick

## anime.sh
Show animation with /usr/games/oneko

## camera-and-screen-capture-now
Capture screen and cameras, save files

## delete-old-stuff.sh
Deletes too old files from hardcoded dirs

## dicto_converter
Normalizes all audio files in current dir, save to m4a aac

## divide_filenames_with-minus
Renames files from '20190530T140447.ogg' -> '2019-05-30-14-04-47.ogg'

## dobro-backup.sh
Downloads all scripts from this repository, backups some other hardcoded files

## empty_dirs_and_files_delete
Deletes empty dirs and files

## extension_file_divider
Separetes files to different directories depends of file extension

## extlower
Convert the extension to lower case

## fake-http-server-start.sh
Starts fake http server on 8080 port

## files_renamer.php
Strange file-renamer on php and bash

## functions.php
PHP-functions

## generate_image_from_text
Generate random image from text with ImageMagick
First argument is "a text"

## generate_video_from_text
Generate random video from text with ImageMagick and ffmpeg
First argument is "a text".
8K-4320p Example: https://www.youtube.com/watch?v=kR5F1z87DMA

## host-is-online.sh
Save to log info about runtime, network usage, memory, etc

## hostname-change-root.sh
Change /etc/hostname, based on /var/lib/tor/host/hostname

## list_recursive
Show recursive list of files with sizes

## md5here
Gets md5sum of files in current directory. Possible using: find . -type d -exec md5here '{}' \; | tee md5sum-all-`date "+%F"`.md5 

## minimize-all-windows.sh
Minimize all windows in KDE with wmctrl -l

## modifydate-add-to-fname
Script renames file in current directory. Adds file modify date before file name. Uses exiftool 

## morph-images
Morphing images with G'MIC

## pause
Windows-like pause (Press any key to continue)

## photo_rename_by_date
Create dirs like '2023-05-31' for every file like '2023-05-31-14-04-47.jpg', and move files into dirs

## plasmashell-restart.sh
Restart KDE plasmashell if it swallows too much RAM

## prefix_rename
Add prefix to all files in current directory. Prefix is the first argument.

## run-on-next-reboot.sh
File will run on next system load

## sanitize_filenames
Removes some strings from filenames in current directory

## screenshot-now
Save screenshot to $HOME/screenshots/

## sdcard-create-dirs
Creates some dir on current dir

## set-date-from-name
Sets file creation date from file name. Works with filenames like "2019-06-08-09-22-03--1118ms-1.jpg"

## start-display.sh
Script starts after X-window system starts.
Set keyboard layout switch

## swap-start.sh
Create swap on system start

## trim-fs.sh
trim filesystem on SSD

## vidstabdir
Batch video stabilization, sound normalize

## ydisk-killer
Starts yandex-disk daemon and kills it rhythmically
