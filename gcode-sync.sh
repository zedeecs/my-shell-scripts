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
# targetFolder=$4
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
    echo "umount "$mountFolder""
}

sync_gcode() {
    echo -e "\033[33mStart sync file ......\033[0m"
    echo "$(date "+%Y-%m-%d %H:%M:%S") start sync" >~/gcode-sync.log
    # echo "rsync --dry-run -aAXv --bwlimit=800 --progress --time-limit=7 -delete --exclude=".metadata.json" "$mountFolder"/ "$targetFolder"/ >>~/gcode-sync.log"
    rsync --dry-run -aAXv --bwlimit=800 --progress --size-only --time-limit=7 -delete --exclude=".metadata.json" $mountFolder/ $targetFolder/ >>~/gcode-sync.log
    # echo "rsync --dry-run -aAXv --bwlimit=800 --progress --size-only --time-limit=7 -delete --exclude=".metadata.json" /mnt/gcode/ ~/octoprint/octoprint/uploads/ >>~/gcode-sync.log"
    # NOTICE '/' in end of "$n"

    echo "$(date "+%Y-%m-%d %H:%M:%S") finish sync" >>~/gcode-sync.log
    echo -e "\033[33mTime-limit\033[0m sync complete"
}
main() {
    creat_mount_folder
    mount_samba
    sync_gcode
    umount_samba
}

main $@
