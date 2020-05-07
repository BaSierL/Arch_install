#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git
r='\033[1;31m'	#---红
g='\033[1;32m'	#---绿
y='\033[1;33m'	#---黄
b='\033[1;36m'	#---蓝
w='\033[1;37m'	#---白
h='\033[0m'		#---后缀

# 更改時區
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

curl -fsSL https://gitee.com/auroot/Arch_install/tree/master > /tmp/Script_Update_Time 
# 每次更新源后创建最后时间
#INITIALIZE=$(cat /tmp/Script_Update_initialize)
# 使用命令获取最后修改时间
# 只适合英文
#INITIALIZE=$(stat $PWD/Arch_install.sh |grep  -i Change | awk -F. '{print $1}' | awk '{print $2$3}'| awk -F- '{print $1$2$3}' | awk -F: '{print $1$2$3}')
# 获取文件 最近改动 时间
INITIALIZE=$(stat $PWD/Arch_install.sh | awk 'NR==6{print}' | awk -F. '{print $1}' | tr -cd "[0-9]" | cut -d"%" -f1)
# 获取最新主脚本 最后修改时间
SCRIPT_NOW_TIME=$(cat /tmp/Script_Update_Time | awk 'NR==1141{print}' | awk  '{print $5$6}' | tr -cd "[0-9]" | cut -d"%" -f1)

# 当前时间
# NOW_TIME=$(hwclock | awk -F. '{print $1}' | awk '{print $1$2$3}' | awk -F- '{print $1$2$3}' | awk -F: '{print $1$2$3}')
NOW_TIME=$(hwclock | awk -F. '{print $1}')
if [[ ${INITIALIZE} -le ${SCRIPT_NOW_TIME} || $1 == "yes" ]] ; then
    READS_TIPS=$(echo -e "${b}-=>${h} ${b}Update Script [ Y/n ]: ${h}")
    read -p "${READS_TIPS}" UPDATE_SCRIPT
        if [[ ${UPDATE_SCRIPT} == y || ${UPDATE_SCRIPT} == Y || ${UPDATE_SCRIPT} == yes ]] ; then
            curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/Arch_install.sh > $PWD/Arch_install.sh
            echo;
            touch -d "${NOW_TIME}" $PWD/Arch_install.sh && echo -e "${g} ::==>${h} ${g}Update script complete. [OK]!${h}"
            # echo "${TIME_UPDATE}" > /tmp/Script_Update_initialize
        fi
fi

