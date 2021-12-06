#!/bin/bash
# pull scripts form Github in MY-SHELL-SCRIPTS repository

pull_script() {
    wget -P $tmpdir "https://github.com/zedeecs/my-shell-scripts/raw/main/$file"
    # 下载到指定目录
}

mv_script() {
    echo -e "mv $tmpdir'/'$file /tmp"
}

creat_tmpdir() {
    tmpdir=$(mktemp -d --tmpdir sync_scripts.XXXXXX)
}

main() {
    for file in $(ls -a $(pwd)); do
        if [ ! -z $(echo $file | grep -e ^[[:alnum:]].*[.]sh\$) ]; then # grep 语句里的 '[.]' 匹配 '.' , 用 '\.' 不成功
            echo $file
            pull_script $file
            move_script
        fi
    done
}

# wget -P /$location https://github.com/zedeecs/my-shell-scripts/raw/main/v2ray-restart.sh
# # 下载到指定目录

creat_tmpdir
echo tmpdir = $tmpdir
main $@
