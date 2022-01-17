# [my-shell-scripts](https://github.com/zedeecs/my-shell-scripts)

## [dynv6.sh](https://github.com/zedeecs/my-shell-scripts/blob/main/gcode-rename.sh)
> dynv6 的修改版本
- 优化 IPv6 地址的提取正则表达式，只提取末尾为 2~4 位的地址
- 禁用 IPv4 的更新
- 每次更新地址都记录日志，保存位置：`./dynv6.log`

## [gcode-rename.sh](https://github.com/zedeecs/my-shell-scripts/blob/main/gcode-rename.sh)
> 重命名文件名内包含 `NF_` 的 `gcode` 文件
- 将 `NF_` 提到文件名的开头，方便识别
- 将来增加遍历功能，能处理子文件夹

## [gcode-sync.sh](https://github.com/zedeecs/my-shell-scripts/blob/main/gcode-sync.sh)
> 通过 `rsync` 同步 `gcode` 文件  
用法：
```
bash /path-to-script/gcode-sync.sh timeLimit sourceFolder targetFolder 
```
- `timeLimit` 是脚本运行持续时间，单位：分钟
  > *应该有个 `0` 值表示不限制持续时间才对*
- `sourceFolder` 是源文件的地址，只支持 `samba` 协议共享的地址(eg: //192.168.1.2/share)
- `targetFolder` 目标地址，(eg: ~/.octoprint/uploads)

## [new_linux.sh](https://github.com/zedeecs/my-shell-scripts/blob/main/new_linux.sh)
> 初始化 `armbian for orangepi` 的脚本
- 启用 `SSH` 验证，关闭密码验证
- 调用 `sudo` 命令不再需要输入密码
- 自定义 `echo` 命令的颜色调用函数，文字改色更加优雅
- 脚本未完成

## [pull-my-scripts.sh](https://github.com/zedeecs/my-shell-scripts/blob/main/pull-my-scripts.sh)
> 从 Github 拉取我的脚本，以方便保持更新
- 只更新本地已有的脚本
- 未完成

## [v2ray-restart.sh](https://github.com/zedeecs/my-shell-scripts/blob/main/v2ray-restart.sh)
> 监控这东西的脚本  
> 有时候发现这东西占用 `100%`, 所以写了这个脚本，不老实就重启它一下  
> 
实现原理在源码内