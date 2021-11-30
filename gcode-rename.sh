#!/bin/bash
# 重命名文件
# 将gcode文件名的 "NF_" 标记移动到文件头部，以方面识别和分类

log=./rename.log
# log 记录的位置

# read -p "输入需要处理的文件后缀名(etc: type): " file_type
# 获取输入的后缀名，以便脚本拓展应用到其他文件类型

echo -e "Change '$file_type' file name bash\n" >$log

for file in $(ls *$file_type); do
    # 循环读取当前文件夹内的文件
    old_name=$file
    name=$(echo $file | grep NF_ | sed -r 's/(.*)(NF_)(.*\.gcode)/\2\1\3/')
    # echo -e "name: $name\nold_name: $old_name\n" >> $log
    if [ -z $name ]; then
        echo -e "old_name: $old_name\nname:     不匹配\n" >>$log
    else
        mv ./$old_name ./$name
        # 重命名
        echo -e "old_name: $old_name\nname:     $name\n" >>$log
    fi
done
