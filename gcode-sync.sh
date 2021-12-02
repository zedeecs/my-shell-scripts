#!/bin/bash
# Sync gcode file from samba share folder with rsync tool
# version: 1.0.0
# 2021.12.2
#
# usage: bash ./gcode-sync.sh timeLimit sourceFolder targetFolder
# eg: bash ./gcode-sync.sh 5 //192.168.9.2/gcode ~/.octoprint/uploads
#

timeLimit=$1
sourceFolder=$2
targetFolder=$3
# eg: ~/octoprint/octoprint/uploads

# echo -e "\$1 = $1\n\$2 = $2\n\$3 = $3\n\$4 = $4"

creat_mount_folder() {
    mountFolder=$(mktemp -d --tmpdir gcode_sync.XXXXXX)
    echo -e "Creat temporary mount folder: $mountFolder"
}

mount_samba() {
    # echo -e "Mount \"$mountFolder\" ......"
    sudo mount -t cifs -o username=Everyone "$sourceFolder" "$mountFolder"
    if [ $? -ne 0 ]; then
        echo -e "\033[31mFailed\033[0m to mount: \"$sourceFolder\""
        exit 1
    else
        echo -e "\033[32mSuccess\033[0m mount: \"$sourceFolder\""
    fi
}

umount_samba() {
    sudo umount "$mountFolder"
    if [ $? -eq 0 ]; then
        echo "\033[32mSuccess\033[0m umount "$mountFolder""
    else
        echo "\033[31mFailed\033[0m to umount "$mountFolder""
        exit 1
    fi
}

sync_gcode() {
    echo -e "\033[33mStart sync file ......\033[0m"
    echo "$(date "+%Y-%m-%d %H:%M:%S") start sync" >~/gcode-sync.log
    rsync --dry-run -aAXv --bwlimit=800 --progress --time-limit=$timeLimit -delete --exclude=".metadata.json" $mountFolder/ $targetFolder/ >>~/gcode-sync.log
    # NOTICE '/' in end of "$path"

    echo "$(date "+%Y-%m-%d %H:%M:%S") finish sync" >>~/gcode-sync.log
    echo -e "\033[33mTime-limit\033[0m sync complete"
}
main() {
    creat_mount_folder
    sleep 1
    mount_samba
    sleep 1
    sync_gcode
    sleep 1
    umount_samba
    rm -r $mountFolder
}

main $@
