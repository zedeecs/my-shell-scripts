#!/bin/bash
# 最近一段时间，v2ray 莫名满负载，造成 Pi 温度过高
# 结合crontab 判断cpu占用，并执行v2ray重启

cpu_load=$(top -b -d 1 -n 1 | grep 'load average: [4-9]' | sed -n 's/.* load average\: \([4-9]\)\..*/\1/p')
# 获取1分钟内`load average` 的值，如果在4-9之间，说明满载，重启v2ray进程
# top 的 `load average`3个数值 1、5、15分钟内的平均负载值，与CPU线程有关，这里是4核，当数值为4时，说明已经满载了

if [ -z "$cpu_load" ]; then
  echo $(date "+%Y-%m-%d %H:%M:%S") "V2ray is WORKING GOOD"
  # 显示日期，并提示"V2ray is WORKING GOOD"

else
  sudo systemctl restart v2ray
  echo $(date "+%Y-%m-%d %H:%M:%S")   "CPU_LOAD = $cpu_load"      "Rebooting" >> ./reboot_v2ray.Log
  # 执行重启v2ray操作，并将日期、LOAD、提示语句添加到./reboot_v2ray_Log.txt文件最后一行
fi
