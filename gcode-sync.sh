#!/bin/bash
# Sync gcode file from mounted folder with rsync tool
# 1) creat /mnt/gcode
# 1) mount server gcode folder to /mnt/gcode

echo -e "Creat /mnt/gcode ......"
sleep 30
sudo mkdir -p /mnt/gcode

if [ $? -ne 0 ]; then
    echo -e "\033[31mFailed\033[0m to creat mount folder: /mnt/gcode"
    exit 1
else
    echo -e "\033[32mSuccess\033[0m creat mount folder: /mnt/gcode"
fi

echo
echo -e "Mount /mnt/gcode ......"
sleep 1
sudo umount /mnt/gcode
sudo mount -t cifs -o username=Everyone //192.168.9.33/Public/.gcode /mnt/gcode

if [ $? -ne 0 ]; then
    echo -e "\033[31mFailed\033[0m to mount: /mnt/gcode"
    exit 1
else
    echo -e "\033[32mSuccess\033[0m mount: /mnt/gcode"
fi

echo
echo -e "\033[33mStart sync file ......\033[0m"
sleep 1
echo $(date "+%Y-%m-%d %H:%M:%S") start sync > ~/gcode-sync.log
# rsync --dry-run -aAXv --bwlimit=100 --progress --time-limit=20 -delete --exclude=".metadata.json" /mnt/gcode/ ~/octoprint/octoprint/uploads/ >> ~/gcode-sync.log
rsync -aAXv --bwlimit=800 --progress --time-limit=7 -delete --exclude=".metadata.json" /mnt/gcode/ ~/octoprint/octoprint/uploads/ >> ~/gcode-sync.log
echo $(date "+%Y-%m-%d %H:%M:%S") finish sync >> ~/gcode-sync.log

sudo umount /mnt/gcode

# echo -e "\033[32mSuccess\033[0m sync complete"
echo -e "\033[33mTime-limit\033[0m sync complete"