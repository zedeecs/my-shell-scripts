#!/bin/bash
# 新系统初始化
# 1) 系统安全方面，启用SSH验证，关闭密码验证
# user=$(whoami)

# function RText(){
#     echo -e "\e[31m$1\e[0m"
#     return echo "\e[31m$1\e[0m"
# }
# RText sdff

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

update_system() {
    sudo apt update
    if [[ $? -eq 0 ]]; then
        echo -e "System update $(echo_clr -GREen SUCCESS)"
    else
        echo -e "System update $(echo_clr -red FAIL)"
        exit 1
    fi
}

check_if_running_as_root() {
    # If you want to run as another user, please modify $UID to be owned by this user
    if [[ "$UID" -eq '0' ]]; then
        echo_clr -red "error: NOT run this script as root!"
        # echo "not"
        exit 1
    fi
}

check_public_keys() {
    if [ -z ~/.ssh/authorized_keys ]; then
        echo "no Public keys, you need add one!"
    else
        echo "already have Public keys!"
    fi
}

turn_off_PasswordAuthentication() {
    echo

}

sudo_without_passowrd() {
    echo -e "\n\n为用户: $(whoami) 启用免密 sudo"
    sleep
    echo -e "$(whoami) ALL=(ALL) NOPASSWD: ALL" >> sudo /etc/sudoers
    # echo -e "\n$(echo_clr -green "$(whoami) ALL=(ALL) NOPASSWD: ALL")\n"
    # echo -n "复制完毕后按任意键进入下一步, 粘贴到文本的末尾并保存"
    # read -r
    # sudo visudo
    echo done
    # /etc/sudoers
}

main() {
    # update_system
    # check_if_running_as_root
    check_public_keys
    sudo_without_passowrd

}

main "$@"
