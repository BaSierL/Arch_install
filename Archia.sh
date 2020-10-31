s#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Arch Linux 安装脚本  V4.0
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git
# 脚本文件:/tmp/Arch_install_script.log
# Pacman安装日志: /tmp/install_programs.log
# Archin目录为临时数据,安装过程中需要用来读取

#====脚本颜色变量-------------#
r='\033[1;31m'	#---红
g='\033[1;32m'	#---绿
y='\033[1;33m'	#---黄
b='\033[1;36m'	#---蓝
w='\033[1;37m'	#---白
h='\033[0m'		#---后缀
#-----------------------------#
rw='\033[1;41m'    #--红白
wg='\033[1;42m'    #--白绿
ws='\033[1;43m'    #--白褐
wb='\033[1;44m'    #--白蓝
wq='\033[1;45m'    #--白紫
wa='\033[1;46m'    #--白青
wh='\033[1;46m'    #--白灰
bx='\033[1;4;36m'  #---蓝 下划线
#-----------------------------#
# 交互 蓝
JHB=$(echo -e "${b}-=>${h} ")
# 交互 红
JHR=$(echo -e "${r}-=>${h} ")
# 交互 绿
JHG=$(echo -e "${g}-=>${h} ")
# 交互 黄
JHY=$(echo -e "${y}-=>${h} ")
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
#------------------------------变量------------------------------#
# 文件位置变量
tmps="$PWD/arch_tmp"
# mirrorlist.sh 脚本位置
MIRROR_SH="$PWD/mirrorlist.sh"
chmod +x ${MIRROR_SH} 2&>/dev/null

# 位置
LIST_IN="$PWD/$0"
# 初始密码
PASS="123456"
#systemctl start dhcpcd &> /dev/null
#========网络变量
#有线
ETHERNET=`ip link | grep 'enp[0-9]s[0-9]' |  grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`  
#无线
WIFI=`ip link | grep 'wlp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`   

#WIFI_IP=`ifconfig ${WIFI} &> $null || echo "--.--.--.--" && ifconfig ${WIFI} | grep ./a"inet " |  awk '{print $2}'`
#ETHERNET_IP=`ifconfig ${ETHERNET} &> $null || echo "--.--.--.--" && ifconfig ${ETHERNET} | grep "inet " |  awk '{print $2}'`

ETHERNET_IP=`ip route | grep "${ETHERNET}" &> /dev/null && ip route list | grep "${ETHERNET}" | cut -d" " -f9 | sed -n '2,1p'`  
WIFI_IP=`ip route | grep ${WIFI} &> /dev/null && ip route list | grep ${WIFI} |  cut -d" " -f9 | sed -n '2,1p'`

# 当前时间
Time_Up=$(date -d "2 second" +"%Y-%m-%d %H:%M:%S")

Programs=" "

#-------------------------------函数-------------------------------#
# 显示Archlogo与提示
ArchLogo(){
    #------ArchLinux
    clear;
    ArchLogoA=$(echo -e "${w}    _             _       _     _                    ${h}") 
    ArchLogoB=$(echo -e "${g}   / \   _ __ ___| |__   | |   (_)_ __  _   ___  _   ${h}")
    ArchLogoC=$(echo -e "${b}  / _ \ | '__/ __| '_ \  | |   | | '_ \| | | \ \/ /  ${h}")
    ArchLogoD=$(echo -e "${y} / ___ \| | | (__| | | | | |___| | | | | |_| |>  <   ${h}")
    ArchLogoE=$(echo -e "${r}/_/   \_\_|  \___|_| |_| |_____|_|_| |_|\__,_/_/\_\  ${h}")
    #========选项
    Tips1=$(echo -e "${b}||====================================================================||${h}")
    Tips2=$(echo -e "${b}|| Script Name:        Arch Linux system installation script.           ${h}") 
    Tips3=$(echo -e "${b}|| Author:             Auroot                                           ${h}")
    Tips4=$(echo -e "${b}|| Gitee:	       ${bx}https://gitee.com/auroot/Arch_install${h}        ${h}")  
    Tips5=$(echo -e "${g}|| Pattern:            ${ChrootPattern}                                 ${h}")
    Tips6=$(echo -e "${g}|| Ethernet:           ${ETHERNET_IP:-No_network..}                     ${h}")
    Tips7=$(echo -e "${g}|| WIFI:	       ${WIFI_IP:-No_network.}                               ${h}")
    Tips8=$(echo -e "${g}|| SSH:                ssh $USER@${ETHERNET_IP:-IP_Addess.}             ${h}")
    Tips9=$(echo -e "${g}|| SSH:                ssh $USER@${WIFI_IP:-IP_Addess.}                 ${h}")
    Tips0=$(echo -e "${g}||====================================================================||${h}")
    echo -e "$ArchLogoA\n$ArchLogoB\n$ArchLogoC\n$ArchLogoD\n$ArchLogoE" | lolcat 2> /dev/null || echo -e "$ArchLogoA\n$ArchLogoB\n$ArchLogoC\n$ArchLogoD\n$ArchLogoE"
    echo -e "$Tips1\n$Tips2\n$Tips3\n$Tips4\n$Tips5\n$Tips6\n$Tips7\n$Tips8\n$Tips9\n$Tips0" | lolcat 2> /dev/null || echo -e "$Tips1\n$Tips2\n$Tips3\n$Tips4\n$Tips5\n$Tips6\n$Tips7\n$Tips8\n$Tips9\n$Tips0"
}
# 副脚本
ViceScript(){
ViceScript_FILE="${PWD}/Archib"
    if [ ! -e ${ViceScript_FILE} ]; then
        curl -fsSL https://gitee.com/auroot/Arch_install/blob/Archin/Archib  > Archib 
        chmod +x Archib
        bash ${ViceScript_FILE}
    else
        bash ${ViceScript_FILE}
    fi
}
# 日志记录函数
Write_Log(){
    cat /tmp/install_Temp | echo -e "  ${Time_Up}: \n$(cat /tmp/install_Temp)" >> /tmp/Arch_install_script.log 
    echo "#-----------------------分割线-----------------------#" >> /tmp/Arch_install_script.log 
    rm -rf /tmp/install_Temp
}
#--函数------检查当前目录有没有update.sh文件，没有就导入
Down_Update(){
    if [ ! -e update.sh ]; then
        curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/update.sh > update.sh  
        chmod +x update.sh
    fi
    bash $PWD/update.sh  # 检查更新Arch_install.sh
}
#--------检查当前目录有没有mirrorlist.sh文件，没有就导入
Down_Mirrorlist(){
    if [ ! -e mirrorlist.sh ]; then
        curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh  > mirrorlist.sh  
        chmod +x mirrorlist.sh
    fi
}
#--函数------安装软件
Pacmans(){
    sudo pacman -Sy --needed --noconfirm ${Programs} | tee -a /tmp/install_Temp >> /tmp/install_programs.log  # --needed 如果程序已存在即不安装,--noconfirm 不进行交互,直接安装
    if [[ $? == 0 ]]; then
        echo -e "${PSG} ${g}The installation is complete. ${h}"
    else
        echo -e "${PSR} ${r} installation failed!!! ${h}"
    fi
}
#========ArchLinux Mirrorlist 配置镜像源
Mirrorlist(){
PACMANCONF_FILE="/etc/pacman.conf"
MIRRORLIST_FILE="/etc/pacman.d/mirrorlist"
    # 检查"/etc/pacman.d/mirrorlist"文件是否存在
    if [ -e ${MIRRORLIST_FILE} ] ; then      
        # 本地 
        sh ${MIRROR_SH} | tee -a /tmp/install_Temp && Write_Log
        # 远程
        #sh ${MIRROR_SH} || sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)" 
    else
        # 本地 
        touch ${MIRRORLIST_FILE} && sh ${MIRROR_SH} | tee -a /tmp/install_Temp && Write_Log
        # 远程
        #touch ${MIRRORLIST_FILE} && sh ${MIRROR_SH} || sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)" 
    fi
    clear && echo;
    # bash $PWD/update.sh | tee -a /tmp/install_Temp #&& Write_Log
    bash ${0}
}
NetWorks(){
    READS_B=$(whiptail --title "Networm Menu" --menu "Ethernet: ${ETHERNET}                 Wifi: ${WIFI}" 10 50 2 \
        "1" "Ethernet" \
        "2" "Wifi" 3>&1 1>&2 2>&3)
        case ${READS_B} in
            1) 
                echo ":: One moment please............"
                ls /usr/bin/ifconfig &> $null && echo ":: Install net-tools" || sudo pacman -Sy --needed ifconfig | tee -a /tmp/install_Temp && Write_Log
                ip link set ${ETHERNET} up | tee -a /tmp/install_Temp 
                ifconfig ${ETHERNET} up | tee -a /tmp/install_Temp 
                systemctl restart dhcpcd | tee -a /tmp/install_Temp
                ping -c 3 14.215.177.38 | tee -a /tmp/install_Temp && Write_Log
                sleep 1
                bash ${0}    
            ;;
            2) 
                echo;
                wifi-menu &&  ping  -c 3 14.215.177.38 
                sleep 1 
                bash ${0}
            ;;
        esac
}
##========开启SSH 3
SSH(){
    echo ${USER}:${PASS} | chpasswd &> $null
    NetInfo_A=$(echo -e "ssh $USER@${ETHERNET_IP:-IP_Addess..}")
    NetInfo_B=$(echo -e "ssh $USER@${WIFI_IP:-IP_Addess..}")
    NetInfo_C=$(echo -e "Username -> $USER")
    NetInfo_D=$(echo -e "Password -> $PASS")
    whiptail --title "SSH Menu" --menu "Choose your favorite programming language." 15 60 4 \
    " " "${NetInfo_A}" \
    " " "${NetInfo_B}" \
    " " "${NetInfo_C}" \
    " " "${NetInfo_D}"  3>&1 1>&2 2>&3
        systemctl start sshd.service
        netstat -antp | grep sshd
}

#------------------------------从这里开始------------------------------#
# 记录脚本已启动
echo "Arch_install Script started || Arch_install 脚本已启动 \n\t\t${Time_Up}" >> /tmp/Arch_install_script.log 
# 应用函数  如果觉得每次打开脚本,速度很慢,可以注释下面一行!
#Down_Update
# 检查当前目录有没有mirrorlist.sh文件，没有就导入
Down_Mirrorlist

#========判断当前模式
#------因暂时还不知道怎么得知当前是否为Chroot模式，所以必须使用脚本分区后，才知道处于什么模式！
#------如果是以自行分区，也可以手动在 新系统根目录创建/mnt/diskName_root文件，文件上级目录必须为 /mnt
if [ -e /diskName_root ]; then
    ChrootPattern=$(echo "Chroot-ON$")
else
    ChrootPattern=$(echo "Chroot-OFF")
fi

ArchLogo && sleep 3;

Root=$(whiptail --title "Install ArchLinux Home" --menu "Please select.                      Ststus: ${ChrootPattern}"       15 60 5 \
        "1" "Configure Mirrorlist" \
        "2" "Configure Network" \
        "3" "Configure SSH" \
        "4" "Install System" \
        "5" "Exit Script" 3>&1 1>&2 2>&3)

case ${Root} in
    1)
        Mirrorlist;
    ;;
    2)
        NetWorks;
    ;;
    3)
        SSH;
    ;;
    4)
        ViceScript
    ;;
    5)
        exit 0;
    ;;
esac

