#!/bin/bash
# 结合crontab 判断cpu占用，并执行v2ray重启

cpu_load=$(top -b -d 1 -n 1 | grep 'load average: [4-9]' | sed -n 's/.* load average\: \([4-9]\)\..*/\1/p')

if [ -z "$cpu_load" ]; then
  echo low
else
  echo $cpu_load
  sudo systemctl restart v2ray
fi