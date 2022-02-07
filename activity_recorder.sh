#!/bin/sh
#Script record screencast when user move mouse

NEWDIR="$HOME/screencasts/"; TEMPDIR="/dev/shm/screencast/"; mkdir -pv "$NEWDIR"; mkdir -pv "$TEMPDIR";  events_file="$TEMPDIR/events.txt"; temp_file="$TEMPDIR/screencast_temp.mkv";
rm -v "$events_file";
nohup xinput test-xi2 --root | sed 's/[^7]//g' > "$events_file" & \
touch "$events_file";
while true;
do date;
no_activity_wait_sec=1799;
fps=0.033333;
CUR_RESOLUTION=`xdpyinfo | grep 'dimensions:'| awk '{print $2}'`;
screencast_file="$NEWDIR/`date +%Y-%m-%d-%H-%M-%S`.mkv";
temp_file="$NEWDIR/`date +%Y-%m-%d-%H-%M-%S`-temp.mkv";
echo "$CUR_RESOLUTION -- $screencast_file";
nice -n 19 ffmpeg -nostdin -y -hide_banner -threads 1 -r ${fps} \
-f x11grab -s $CUR_RESOLUTION -i :0.0 -vf format=pix_fmts=yuv420p,scale=w='trunc(min(1920\,iw)/2)*2':h='trunc(min(1080\,ih)/2)*2':force_original_aspect_ratio=decrease:flags=lanczos,setsar=1:1,pad=width='ceil(iw/2)*2':height='ceil(ih/2)*2' \
-t "$no_activity_wait_sec" \
-profile:v main -vcodec libx265 -preset veryslow -crf 51 -movflags faststart \
"$temp_file";

if [ $(($(date +%s) - $(date +%s -r "${events_file}"))) -gt $no_activity_wait_sec ];
then echo -e "\n\n\nNo activity. Delete last file.\n\n\n";
rm -v "$temp_file"; sleep 1;
else echo "activity detected. Let's save last file and record next file";
truncate --size 0 "$events_file";
mkvmerge -o "${screencast_file}" --default-duration 0:30fps --fix-bitstream-timing-information 0 "${temp_file}";
sleep 1;
cp --no-clobber -v "${temp_file}" "${screencast_file}";
rm -v "$temp_file"; sleep 1;
sleep 1;
fi;
done;

