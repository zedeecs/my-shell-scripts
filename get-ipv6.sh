#!/bin/bash
# get ipv6 address from ip command with regex
# good for dynv6.sh

ip -6 addr list scope global dynamic $device | grep -v " fd" | sed -n 's/.*inet6 \(\([0-9a-f]\{1,4\}\:\:\?\)\+[0-9a-f]\{2,4\}\)\/.*/\1/p' | head -n 1