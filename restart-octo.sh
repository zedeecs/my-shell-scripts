#!/bin/bash
# 这个脚本旨在于监视OctoPrint是否正常工作
# 传入多个Gcode执行扫描计算的过程中，Octo可能中途停止工作
# 原理：通过检查CPU温度来判断其是否正在满载计算，如果温度低于阈值，则重启进程

active_temp=$((65))  # 设置触发重启的温度阈值
cpu_temp=`expr $(cat /sys/class/thermal/thermal_zone0/temp) / 1000`

echo "cpu_temp = $cpu_temp"
if [ $cpu_temp -lt $active_temp ]; then
    echo working...
    # sudo apt update
fi
