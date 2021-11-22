#!/bin/bash
# 树莓派可用


vcgencmd measure_temp | sed -E 's/temp=([0-9]{1,3}.[0-9]).*/\1/g'