#!/bin/bash
# Sync gcode file from mounted sambar share folder with rsync tool
# 1) creat /mnt/gcode
# 1) mount server gcode folder to /mnt/gcode
timeLimit=$1
# eg: 7
sourceFolder=$2
# eg: //192.168.9.33/Public/gcode
mountFolder=$3
# eg: /mnt/gcode
targetFolder=$4
# eg: ~/octoprint/octoprint/uploads

# echo -e "\$1 = $1\n\$2 = $2\n\$3 = $3\n\$4 = $4"

creat_mount_folder() {
    if [ ! -d $mountFolder ]; then
        echo -e "Creat $mountFolder ......"
        sudo mkdir -p "$mountFolder"
        # echo -e "sudo mkdir -p $mountFolder"
        if [ ! -d $mountFolder ]; then
            echo -e "\033[31mFailed\033[0m to creat mount folder: \"$mountFolder\""
            exit 1
        else
            echo -e "\033[32mSuccess\033[0m creat mount folder: \"$mountFolder\""
        fi
    else
        echo -e "\nFolder \"$mountFolder\" is already exist! Prepare to mount samba share folder."
    fi

}

mount_samba() {
    echo
    echo -e "Mount "$mountFolder" ......"
    sleep 1
    sudo umount "$mountFolder"
    sudo mount -t cifs -o username=Everyone "$2" "$3"

    if [ $? -ne 0 ]; then
        echo -e "\033[31mFailed\033[0m to mount: "$3""
        exit 1
    else
        echo -e "\033[32mSuccess\033[0m mount: "$3""
    fi
}

umount_samba() {
    echo
}

sync_gcode() {
    echo
    echo -e "\033[33mStart sync file ......\033[0m"
    sleep 1
    echo $(date "+%Y-%m-%d %H:%M:%S") start sync >~/gcode-sync.log
    rsync -aAXv --bwlimit=800 --progress --time-limit=7 -delete --exclude=".metadata.json" "$3"/ "$4"/ >>~/gcode-sync.log
    # NOTICE '/' in end of "$n"

    echo $(date "+%Y-%m-%d %H:%M:%S") finish sync >>~/gcode-sync.log

    sudo umount "$3"

    echo -e "\033[33mTime-limit\033[0m sync complete"
}

creat_mount_folder $@
