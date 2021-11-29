#!/bin/bash
# pull 脚本，从github
location=tmp

test -w /$location/v2ray-restart.sh ; echo $?
# 检查文件是否存在并且可写入, 错误会返回1

wget -P /$location https://github.com/zedeecs/my-shell-scripts/raw/main/v2ray-restart.sh
# 下载到指定目录