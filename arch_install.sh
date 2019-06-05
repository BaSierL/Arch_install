#!/bin/bash
#========变量值
## || 1 0 =1 ,0 1=0
## && 1 0 =0 ,0 1=1
null="/dev/null"
ECHOA=`echo -e "    _             _       _     _                  "`  
ECHOB=`echo -e "   / \   _ __ ___| |__   | |   (_)_ __  _   ___  _        "` 
ECHOC=`echo -e "  / _ \ | '__/ __| '_ \  | |   | | '_ \| | | \ \/ /         "` 
ECHOD=`echo -e " / ___ \| | | (__| | | | | |___| | | | | |_| |>  <           "`  
ECHOE=`echo -e "/_/   \_\_|  \___|_| |_| |_____|_|_| |_|\__,_/_/\_\                "`
echo -e "$ECHOA\n$ECHOB\n$ECHOC\n$ECHOD\n$ECHOE" | lolcat 2> ${null} || echo -e "$ECHOA\n$ECHOB\n$ECHOC\n$ECHOD\n$ECHOE"
#
tmps=/tmp/arch_tmp
#systemctl start dhcpcd &> ${null}
PWDS=`pwd`
KENDEYA="arch_install.sh"
LIST_IN=`echo "${PWDS}/${KENDEYA}"`
PASS="orange"
#========网络
ETHERNET=`ip link | grep 'enp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`  #有线
WIFI=`ip link | grep 'wlp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`   #无线
#WIFI_IP=`ifconfig ${WIFI} &> $null || echo "--.--.--.--" && ifconfig ${WIFI} | grep ./a"inet " |  awk '{print $2}'`
#ETHERNET_IP=`ifconfig ${ETHERNET} &> $null || echo "--.--.--.--" && ifconfig ${ETHERNET} | grep "inet " |  awk '{print $2}'`

ETHERNET_IP=`ip route | grep "${ETHERNET}" &> ${null} && ip route list | grep "${ETHERNET}" | cut -d" " -f9 | sed -n '2,1p'`  
WIFI_IP=`ip route | grep ${WIFI} &> ${null} && ip route list | grep ${WIFI} |  cut -d" " -f9 | sed -n '2,1p'`

#========Arch 源'
region="## China"
ustc="Server = http://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch"
netease="Server = http://mirrors.163.com/archlinux/\$repo/os/\$arch"
mirrorlist="/etc/pacman.d/mirrorlist"
sedname=`sed -n '7,1p' $mirrorlist`
sedserver=`sed -n '8,1p' ${mirrorlist}`
#====脚本颜色变量
b='\033[1;36m'	#---蓝
w='\033[1;37m'	#---白
g='\033[1;32m'	#---绿
r='\033[1;31m'	#---红
y='\033[1;33m'	#---黄
rw='\033[1;41m'   #--红白
h='\033[0m'		#---后缀
#No_IP_Addess=" "

#========选项
echo "#=======================================================#"
echo "# Script Name:        Arch Linux安装脚本"  
echo "# GitHub:	      https://www.basierl.com"
echo "# Author:             Basierl QQ2763833502"
echo "# Ethernet:       ${ETHERNET_IP:-No_network}"
echo "# WIFI:	          ${WIFI_IP:-No_network}"
echo "# SSH:            ssh root@${ETHERNET_IP:-IP_Addess}"
echo "# SSH:            ssh root@${WIFI_IP:-IP_Addess}"
echo "#=======================================================#"
echo;
echo -e ":: 配置PM源 [1]"
echo -e ":: 配置网络 [2]"
echo -e ":: 开始安装 [3]"
echo -e ":: Install SSH [4]"
echo -e ":: 退出脚本 [Q]"
echo;
read -p "要我做什么呢[1,2,3..]?; " principal_variable
#
#========ArchLinux Mirrorlist
echo;
if [[ ${principal_variable} == 1 ]]; then
    read -p "网易[1] 中科大[2] 查看[3] 返回[4]?: " mirror_variable
        case $mirror_variable in
            1)      
                echo;
                sed -i "s@$sedname@$region@" ${mirrorlist}
                sed -i "s@$sedserver@$netease@" ${mirrorlist}
                sed -n '7,8p' ${mirrorlist}
                sleep 3
                echo;
                pacman -Syy || ls /usr/bin/lolcat &> $null && echo "y" |  pacman -S lolcat 
                echo;
                echo;
                bash ${LIST_IN}
                ;;
            2)
                echo;
                sed -i "s@$sedname@$region@" ${mirrorlist}
                sed -i "s@$sedserver@$ustc@" ${mirrorlist}
                sed -n '7,8p' ${mirrorlist}   
                sleep 3    
                echo;
                pacman -Syy || ls /usr/bin/lolcat &> $null && echo "y" |  pacman -S lolcat   
                echo;
                echo; 
                sleep 3     
                bash ${LIST_IN}
                ;;
            3)
                head -n 8 ${mirrorlist}
                echo;
                echo;
                sleep 3
                bash ${LIST_IN}
                ;;
            4) 
                bash ${LIST_IN}
                ;;
        esac
fi
#========检查网络  2
echo;
echo "正在检查当前可用网络设备！"
sleep 2
echo "有线: ${ETHERNET}" 2> $null
echo "无线: ${WIFI}" 2> $null 
##========检查网络 2
echo;
if [[ ${principal_variable} == 2 ]]; then
read -p "请问您查看那个网络有线[1] 无线[2] 配置[3] 返回[4]?: " wlink
case $wlink in
    1) 
        ifconfig ${ETHERNET} 2> /dev/null &&  ping -I ${ETHERNET} -c 3 14.215.177.38 
        sleep 1
        bash ${LIST_IN}      
    ;;
    2) 
        echo;
        echo "我检测到了一下网络，有以下wifi网络可以用."
        iwlist ${WIFI} scan | grep "ESSID:"
    ;;
    3) 
        read -p "配置网络 WIFI[1] ETHERNET[2]?: " SNET
            case ${SNET} in
                1) 
                    echo "请稍等！"
                    ls /usr/bin/ifconfig &> $null && echo "Install net-tools" ||  echo "y" |  pacman -S ifconfig
                    ip link set ${ETHERNET} up
                    ifconfig ${ETHERNET} up
                    systemctl enable dhcpcd &> $null
                    bash ${LIST_IN}
                    sleep 1
                ;;
                2)
                    wifi-menu
                    sleep 2
                    bash ${LIST_IN}
                ;;
                3)
                    sleep 2
                    bash ${LIST_IN}
                ;;
            esac
    ;; 
    4) 
        bash ${LIST_IN}
    ;;
esac
fi
#
##========安装ArchLinux 3
echo;
#ls /sys &> /dev/null && echo "系统是以 UEFI 模式所启动." || echo "系统是以BIOS 或 CSM 所启动."


#
##========开启SSH 4
if [[ ${principal_variable} == 4 ]]; then
    ls /usr/bin/ssh &> $null && echo "Install Openssh" ||  echo "y" |  pacman -S openssh 
    systemctl start sshd.service  &> $null
    netstat -antp | grep sshd
    echo;
    echo "正在设置密码."
    echo ${USER}:${PASS} | chpasswd &> $null
    clear;
    echo "User: ${USER}"
    echo "Password：${PASS}"
    echo;
    bash ${LIST_IN}
fi


#if [[ ${principal_variable} == p || P ]];then
#	bash $ret
#fi
#exit;

# head -n 10 /etc/profile
#查看/etc/profile的最后5行内容，应该是：
# tail  -n 5 /etc/profile
