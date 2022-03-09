#!/bin/bash

routerMode=$1
MAINROUTER="192.168.9.1"
SIDEROUTER="192.168.9.123"
path="./test.conf"
currentRouter=$(sed -n 's/\(^static\srouters=\)\([0-9\.]\+\)\(.*\)/\2/p' $path)

file_write() {
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
    echo switch main router
    file_write --main
    restart_network
    echo sudo docker unpause qbittorrent
}

switch_side_router() {
    echo switch side router
    file_write --side
    echo sudo docker pause qbittorrent
    restart_network
}

identify_router_stat() {
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
            ;;
        esac

    fi

}

restart_network(){
    netInterface=$(ifconfig | grep -B 1 192.168 | head -n 1 | sed 's/\(^[0-9a-z]\+\)\:.*/\1/g')
    echo sudo ifconfig $netInterface down
    echo sudo ifconfig $netInterface up
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
