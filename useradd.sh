#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Arch Linux 安装脚本 
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git
#---------------------------------------------------------------------------#
# 配置用户 Root 密码  
#-----------------------------
#====脚本颜色变量-------------#
r='\033[1;31m'	#---红
g='\033[1;32m'	#---绿
y='\033[1;33m'	#---黄
b='\033[1;36m'	#---蓝
w='\033[1;37m'	#---白
#-----------------------------#
rw='\033[1;41m'    #--红白
wg='\033[1;42m'    #--白绿
ws='\033[1;43m'    #--白褐
wb='\033[1;44m'    #--白蓝
wq='\033[1;45m'    #--白紫
wa='\033[1;46m'    #--白青
wh='\033[1;46m'    #--白灰
h='\033[0m'		   #---后缀
bx='\033[1;4;36m'  #---蓝 下划线
wy='\033[1;41m' 
h='\033[0m'
#-----------------------------#
# 交互 蓝
JHB=$(echo -e "${b}-=>${h}")
# 交互 红
JHR=$(echo -e "${r}-=>${h}")
# 交互 绿
JHG=$(echo -e "${g}-=>${h}")
# 交互 黄
JHY=$(echo -e "${y}-=>${h}")
#-----------------------------
# 提示 蓝
PSB=$(echo -e "${b} ::==>${h}")
# 提示 红
PSR=$(echo -e "${r} ::==>${h}")
# 提示 绿
PSG=$(echo -e "${g} ::==>${h}")
# 提示 黄
PSY=$(echo -e "${y} ::==>${h}")
#-----------------------------
null="/dev/null"
if [ ! -e /tmp/USERNAMES ]; then 
        echo;
        SETTINGS_ROOT_PA=$(echo -e "${PSY} ${g}Settings ${y}Root Password.${h}${JHG} ")
        SETTINGS_ROOT_PB=$(echo -e "${PSY} ${g}Please enter the ${y}Root Password${h}${g} again.${h}${JHG} ")
        SETTINGS_USERNAME=$(echo -e "${PSY} ${g}Settings UserName.${h}${JHG} ")
        SETTINGS_USER_PASS=$(echo -e "${PSY} ${g}Settings Password.${h}${JHG} ")
        read -p "${SETTINGS_ROOT_PA}" ROOT_PASSWORD_A
        read -p "${SETTINGS_ROOT_PB}" ROOT_PASSWORD_B
        if [ ${ROOT_PASSWORD_A} == ${ROOT_PASSWORD_B} ]; then
        echo root:${ROOT_PASSWORD_B} | chpasswd &> $null
            echo;
            echo -e "${PSG} ${g}Root Password setting complete.[OK] ${h}"
            echo "1" > /tmp/USERNAMES
        else    
            echo -e "${PSR} ${r}Two passwords are inconsistent.[X] ${h}"
            exit 30;
        fi
        #---------------------------------------------------------------------------#
        # 配置用户
        #-----------------------------
        echo;
        read -p "${SETTINGS_USERNAME}" USER_NAME
        read -p "${SETTINGS_USER_PASS}" USER_PASSWORD_A
        read -p "${SETTINGS_USER_PASS}" USER_PASSWORD_B
        if [ ${USER_PASSWORD_A} == ${USER_PASSWORD_B} ]; then
            useradd -m -g users -G wheel -s /bin/zsh ${USER_NAME}
            echo ${USER_NAME}:${USER_PASSWORD_B} | chpasswd &> $null
            echo;
            echo -e "${PSG} ${g}Password setting complete.[OK] ${h}"
            echo "${USER_NAME}" > /tmp/USERNAMES
            sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/install_zsh.sh)"
        else    
            echo -e "${PSR} ${r}${USER_NAME} Two passwords are inconsistent.[X] ${h}"
            exit 31;
        fi
        #---------------------------------------------------------------------------#
        # 更改sudo 配置
        #-----------------------------
        echo -e "${PSG} ${g}Configure Sudoers. ${h}"
        function S_LINE() {
            sed -n -e '/# %wheel ALL=(ALL) NOPASSWD: ALL/=' /etc/sudoers
        }
        SUDOERS_LIST=$(S_LINE)
        chmod 770 /etc/sudoers
            sed -i "${SUDOERS_LIST}i %wheel ALL=\(ALL\) NOPASSWD: ALL" /etc/sudoers || echo -e "${PSY} ${y}Configure Sudoers fail. ${h}"
        chmod 440 /etc/sudoers   
else
    exit 0;
fi
