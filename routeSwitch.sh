#!/bin/bash

# v0.1.0
# 2022.03.10
# 适用于树莓派官方镜像
#
# 这个脚本用来切换网关，配合 crontab 计划任务可以实现定时切换
# 脚本包含 暂停/恢复 qbittorrent docker容器的功能
#
# 使用场景：
#	在我的树莓派上配置有两个docker容器，一个是qbittorrent，一个是jellyfin，
#	是jellyfin必须要科学上网才能很好地刮削电影和电视剧的信息，但我不想让
#	qbittorrent趁机连上科学路线浪费我的流量。所以我计划每天早上5点切换到科学
#	路由，jellyfin开始刮削信息，同时暂停qbittorrent容器。半小时后，切换回
#	正常线路，qbittorrent 恢复运行。

routerMode=$1
MAINROUTER="192.168.9.1"
SIDEROUTER="192.168.9.123"
path="/etc/dhcpcd.conf"
currentRouter=$(sed -n 's/\(^static\srouters=\)\([0-9\.]\+\)\(.*\)/\2/p' $path)

file_write() {
    # 通过修改 "/etc/dhcpcd.conf" 文件来切换到旁路由网关
    case $1 in
    --main)
        sed -i 's/\(^static\srouters=\)\([0-9\.]\+\)\(.*\)/\1'$MAINROUTER'/g' $path
        ;;
    --side)
        sed -i 's/\(^static\srouters=\)\([0-9\.]\+\)\(.*\)/\1'$SIDEROUTER'/g' $path
        ;;
    esac
}

switch_main_router() {
    # 切换到主路由，并恢复qbittorrent
    echo "switch main router"
    file_write --main
    restart_network
    sudo docker unpause qbittorrent
}

switch_side_router() {
    # 暂停qbittorrent，并切换到旁路由
    echo "switch side router"
    file_write --side
    sudo docker pause qbittorrent
    restart_network
}

identify_router_stat() {
    # 判断当前路由状态，避免无意义重置网络开关
    if [ -z $currentRouter ]; then
        echo "NO ROUTER IP SETTING"
        exit 1
    else
        case $1 in
        --main | -m)
            if [ $currentRouter = $MAINROUTER ]; then
                echo "current MAIN ROUTER mode"
                exit 0
            fi
            ;;
        --side | -s)
            if [ $currentRouter = $SIDEROUTER ]; then
                echo "current SIDE ROUTER mode"
                exit 0
            fi
            ;;
        *)
            # echo "NO MATCH MODE"
            exit 1
            ;;
        esac

    fi

}

restart_network() {
    netInterface=$(ifconfig | grep -B 1 192.168 | head -n 1 | sed 's/\(^[0-9a-z]\+\)\:.*/\1/g')
    # 通过IP来提取目标网卡信息，因为docker里有很多虚拟网卡T_T
    sudo ifconfig $netInterface down
    sudo ifconfig $netInterface up
}

main() {
    case $routerMode in
    --main | -m)
        identify_router_stat $1
        switch_main_router
        ;;

    --side | -s)
        identify_router_stat $1
        switch_side_router
        ;;

    --print | -p)
        echo -e "current ROUTER IS $currentRouter"
        ;;

    *)
        echo -e "error \nUsage: <script.name> --mode[ main | side | print ] OR -m[ m | s | p ]"
        exit 1
        ;;

    esac
}

main $@
