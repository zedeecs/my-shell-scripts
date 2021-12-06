#!/bin/bash
# pull scripts form Github in MY-SHELL-SCRIPTS repository

echo_clr() {
    while [[ "$#" -gt '0' ]]; do
        case $(echo $1 | tr 'A-Z' 'a-z') in
        '-black')
            echo -e "\e[30m$2\e[0m"
            break
            ;;
        '-red')
            echo -e "\e[31m$2\e[0m"
            break
            ;;
        '-green')
            echo -e "\e[32m$2\e[0m"
            break
            ;;
        '-yellow')
            echo -e "\e[33m$2\e[0m"
            break
            ;;
        '-blue')
            echo -e "\e[34m$2\e[0m"
            break
            ;;
        '-white')
            echo -e "\e[37m$2\e[0m"
            break
            ;;
        *)
            echo "usag: echo_clr "-color "string"""
            break
            ;;
        esac
    done
}

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
