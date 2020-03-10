#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Arch Linux 安装脚本 
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git

#====脚本颜色变量
r='\033[1;31m'	#---红
g='\033[1;32m'	#---绿
y='\033[1;33m'	#---黄
b='\033[1;36m'	#---蓝
w='\033[1;37m'	#---白
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

#========变量值
null="/dev/null"
clear;
ECHOA=`echo -e "${w}    _             _       _     _                  ${h}"`  
ECHOB=`echo -e "${g}   / \   _ __ ___| |__   | |   (_)_ __  _   ___  _        ${h}"` 
ECHOC=`echo -e "${b}  / _ \ | '__/ __| '_ \  | |   | | '_ \| | | \ \/ /         ${h}"` 
ECHOD=`echo -e "${y} / ___ \| | | (__| | | | | |___| | | | | |_| |>  <           ${h}"`  
ECHOE=`echo -e "${r}/_/   \_\_|  \___|_| |_| |_____|_|_| |_|\__,_/_/\_\                ${h}"`
echo -e "$ECHOA\n$ECHOB\n$ECHOC\n$ECHOD\n$ECHOE" | lolcat 2> ${null} || echo -e "$ECHOA\n$ECHOB\n$ECHOC\n$ECHOD\n$ECHOE"

# 文件位置变量
tmps="$PWD/arch_tmp"
# mirrorlist.sh 脚本位置
MIRROR_SH="$PWD/mirrorlist.sh"
# 位置
LIST_IN="$PWD/$0"
# 初始密码
PASS="123456"
#systemctl start dhcpcd &> ${null}


#========网络变量
#有线
ETHERNET=`ip link | grep 'enp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`  
#无线
WIFI=`ip link | grep 'wlp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`   

#WIFI_IP=`ifconfig ${WIFI} &> $null || echo "--.--.--.--" && ifconfig ${WIFI} | grep ./a"inet " |  awk '{print $2}'`
#ETHERNET_IP=`ifconfig ${ETHERNET} &> $null || echo "--.--.--.--" && ifconfig ${ETHERNET} | grep "inet " |  awk '{print $2}'`

ETHERNET_IP=`ip route | grep "${ETHERNET}" &> ${null} && ip route list | grep "${ETHERNET}" | cut -d" " -f9 | sed -n '2,1p'`  
WIFI_IP=`ip route | grep ${WIFI} &> ${null} && ip route list | grep ${WIFI} |  cut -d" " -f9 | sed -n '2,1p'`



#========选项
echo -e "${b}||====================================================================||${h}"
echo -e "${b}|| Script Name:        Arch Linux system installation script.         ||${h}"  
echo -e "${b}|| Author:             Basierl                                        ||${h}"
echo -e "${b}|| GitHub:	       ${bx}https://github.com/BaSierL/arch_install${h}        ${b}||${h}"
echo -e "${g}|| Ethernet:           ${ETHERNET_IP:-No_network..}                                   ||${h}"
echo -e "${g}|| WIFI:	       ${WIFI_IP:-No_network.}                                    ||${h}"
echo -e "${g}   SSH:                ssh $USER@${ETHERNET_IP:-IP_Addess.}                         ${h}"
echo -e "${g}   SSH:                ssh $USER@${WIFI_IP:-IP_Addess.}                         ${h}"
echo -e "${g}||====================================================================||${h}"
echo;
echo -e "${g}:: ==>> Configure Mirrorlist   [1]${h}"
echo -e "${g}:: ==>> Configure Network      [2]${h}"
echo -e "${g}:: ==>> Configure SSH          [3]${h}"
echo -e "${g}:: ==>> Install System         [4]${h}"
echo -e "${g}:: ==>> Exit Script            [Q]${h}"
echo;
READS_A=$(echo -e "${y}:: ==>> What are the tasks[1,2,3..] -=> ${h}")
read -p "${READS_A}" principal_variable

#
#========ArchLinux Mirrorlist 配置镜像源  1 

PACMANCONF_FILE="/etc/pacman.conf"
MIRRORLIST_FILE="/etc/pacman.d/mirrorlist"
if [[ ${principal_variable} == 1 ]]; then
    echo ;
    # 检查"/etc/pacman.conf"文件是否存在
    if [ -e ${PACMANCONF_FILE}  ] ; then
        # 如果存在
        sh ${MIRROR_SH}
    else
        # 如果不存在
        touch ${PACMANCONF_FILE} && sh sh ${MIRROR_SH}
    fi
    # 检查"/etc/pacman.d/mirrorlist"文件是否存在
    if [ -e ${MIRRORLIST_FILE}  ] ; then    
        # 如果存在
        sh ${MIRROR_SH}
    else
        # 如果不存在
        touch ${MIRRORLIST_FILE} && sh sh ${MIRROR_SH}
    fi
    bash ${LIST_IN}
fi

#========检查网络  2
if [[ ${principal_variable} == 2 ]]; then
    echo;
    echo ":: Checking the currently available network."
    sleep 2
    echo -e ":: Ethernet: ${r}${ETHERNET}${h}" 2> $null
    echo -e ":: Wifi:   ${r}${WIFI}${h}" 2> $null 

    READS_B=$(echo -e "${y}:: ==>> Query Network: Ethernet[1] Wifi[2] Configure[3] Exit[4]? -=> ${h}")
    read -p "${READS_B}" wlink
        case $wlink in
            1) 
                clear;
                ifconfig ${ETHERNET} 2> /dev/null || echo "Please configure the network first." &&  ping -I ${ETHERNET} -c 3 14.215.177.38 
                sleep 1
                bash ${LIST_IN}      
            ;;
            2) 
                echo;
                echo ":: The following WiFi is available: "
                iwlist ${WIFI} scan | grep "ESSID:"
            ;;
            3) 
                READNET_A=$(echo -e ":: Configure Network WIFI[1] ETHERNET[2] -=> ")
                read -p "${READNET_A}" SNET
                    case ${SNET} in
                        1) 
                            echo ":: One moment please............"
                            ls /usr/bin/ifconfig &> $null && echo ":: Install net-tools" ||  echo "y" |  pacman -S ifconfig
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
##========开启SSH 3
if [[ ${principal_variable} == 3 ]]; then
    clear
    echo
    echo -e "${y}:: Setting Username / password.${h}"
    echo ${USER}:${PASS} | chpasswd &> $null

    echo -e "${g} ||=================================||${h}"
    echo -e "${g} || $ ssh $USER@${ETHERNET_IP:-IP_Addess..}          ||${h}"
    echo -e "${g} || $ ssh $USER@${WIFI_IP:-IP_Addess..}          ||${h}"
    echo -e "${g} || Username --=>  $USER             ||${h}"
    echo -e "${g} || Password --=>  $PASS           ||${h}"
    echo -e "${g} ||=================================||${h}"

        systemctl start sshd.service
        netstat -antp | grep sshd

fi

##======== 安装ArchLinux    选项4 ==========================================
if [[ ${principal_variable} == 4 ]];then
#
    echo
    echo -e "${r}      Install System Modular${h}"
    echo "---------------------------------------------"
    echo -e "${wh}:: ==>> Disk partition       ${h}${r}**${h}  ${w}[1]${h}"
    echo -e "${wh}:: ==>> Install System Files ${h}${r}**${h}  ${w}[2]${h}"
    echo -e "${wh}:: ==>> Installation GRUB    ${h}${r}**${h}  ${w}[3]${h}"
    echo -e "${wh}:: ==>> Installation Desktop ${h}${b}*   ${w}[4]${h}"    
    echo -e "${wh}:: ==>> Installation Drive   ${h}${b}*   ${w}[5]${h}"
    echo "---------------------------------------------"
echo;
    READS_C=$(echo -e "${y}:: ==>> What are the tasks[1,2,3..] Exit [Q] -=> ${h}")
    read -p "${READS_C}" tasks
#
#==========磁盘分区==========11111111111
        if [[ ${tasks} == 1 ]];then
        clear;
            echo;   # 显示磁盘
            lsblk | egrep "sda|sdb|sdc|sdd|sdg|nvme"
            echo;
            #---AAAA 20----------------磁盘分区-------------------A---#
           # 选择磁盘 #parted /dev/sdb mklabel gpt   转换格式 GPT
            READDISK_A=$(echo -e "${y}:: ==>> Select disk: ${g}/dev/sdX | sdX -=> ${h}")
            read -p "${READDISK_A}"  DISKS_ID  #给用户输入接口
                DISK_NAMEL_A=$(echo "${DISKS_ID}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                if echo $DISK_NAMEL_B |  egrep "^[a-z]*$" &>/dev/null ; then
                    cfdisk /dev/${DISK_NAMEL_A}  
                else
                    clear;
                    echo -e "${r} ==>> Error code [20] Please input: /dev/sdX | sdX? !!! ${h}"
                    exit 20    # 分区时输入错误，退出码。
                fi

                #-------------------分区步骤结束，进入下一个阶段 格式和与挂载分区----------------B------#
                #---BBBB 21----------------root [/]----------------B------#
                echo;
                lsblk | egrep "sda|sdb|sdc|sdd|sdg|nvme"
                echo;
                READDISK_B=$(echo -e "${y}:: ==>> Choose your root[/] partition: ${g}/dev/sdX[0-9] | sdX[0-9] -=> ${h}")
                read -p "${READDISK_B}"  DISK_LIST_ROOT   #给用户输入接口
                    DISK_NAMEL_B=$(echo "${DISK_LIST_ROOT}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                    if echo ${DISK_NAMEL_B} | egrep "^sd[a-z][0-9]$" &>/dev/null ; then
                        mkfs.ext4 /dev/${DISK_NAMEL_B}
                        mount /dev/${DISK_NAMEL_B} /mnt
                        ls /sys/firmware/efi/efivars &> /dev/null && mkdir -p /mnt/boot/efi || mkdir -p /mnt/boot
                    else
                        clear;
                        echo -e "${r} ==>> Error code [21] Please input: /dev/sdX[0-9] | sdX[0-9] !!! ${h}"
                        exit 21    # 分区时输入错误，退出码。
                    fi
                #---CCCC 22----------------EFI / boot----------------C------#
                echo;
                lsblk | egrep "sda|sdb|sdc|sdd|sdg|nvme"
                echo;
                READDISK_C=$(echo -e "${y}:: ==>> Choose your EFI / BOOT partition: ${g}/dev/sdX[0-9] | sdX[0-9] -=> ${h}")
                read -p "${READDISK_C}"  DISK_LIST_GRUB   #给用户输入接口
                    DISK_NAMEL_C=$(echo "${DISK_LIST_GRUB}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                    if echo ${DISK_NAMEL_C} | egrep "^sd[a-z][0-9]$" &>/dev/null ; then
                        mkfs.vfat /dev/${DISK_NAMEL_C}
                        ls /sys/firmware/efi/efivars &> /dev/null && mount /dev/${DISK_NAMEL_C} /mnt/boot/efi || mount /dev/${DISK_NAMEL_C} /mnt/boot
                    else
                        clear;
                        echo -e "${r} ==>> Error code [22] Please input: /dev/sdX[0-9] | sdX[0-9] !!! ${h}"
                        exit 22    # 分区时输入错误，退出码。
                    fi
                #---DDDD 23-----------SWAP file 虚拟文件(类似与win里的虚拟文件) 对于swap分区我更推荐这个，后期灵活更变---------------#
                echo
                lsblk | egrep "sda|sdb|sdc|sdd|sdg|nvme"
                echo;
                READDISK_D=$(echo -e "${y}:: ==>> Please select the size of swapfile: ${g}[example:512M-4G ~] -=> ${h}")
                read -p "${READDISK_D}"  DISK_LIST_SWAP     #给用户输入接口
                    DISK_NAMEL_D=$(echo "${DISK_LIST_SWAP}" |  cut -d"/" -f3)   #设置输入”/dev/sda” 或 “sda” 都输出为 sda
                    if echo ${DISK_NAMEL_D} | egrep "^[0-9]*[A-Z]$" &>/dev/null ; then
                        fallocate -l ${DISK_NAMEL_D} /mnt/swapfile
                        chmod 600 /mnt/swapfile
                        mkswap /mnt/swapfile
                        swapon /mnt/swapfile
                    else
                        clear;
                        echo -e "${r} ==>> Error code [23] Please input size: [example:512M-4G ~] !!! ${h}"
                        exit 23    # 分区时输入错误，退出码。
                    fi
            echo -e "${wg} ::==>> Partition complete. ${h}"
            bash ${LIST_IN} 
        fi 
#
#========== 安装及匹配系统文件 ==========222222222222222
        if [[ ${tasks} == 2 ]];then
            echo -e "${wg}Update the system clock.${h}"  #更新系统时间
                timedatectl set-ntp true
            sleep 2
            echo;
            echo -e ":: ${r}Install the base packages.${h}"   #安装基本系统
            echo;
                pacstrap /mnt base base-devel linux linux-firmware linux-headers ntfs-3g networkmanager net-tools 
	        sleep 2
            echo -e ":: ${r}Configure Fstab File.${h}" #配置Fstab文件
	            genfstab -U /mnt >> /mnt/etc/fstab
            sleep 2
            echo
                cp -rf ${LIST_IN} /mnt &> $nul
                arch-chroot /mnt /bin/bash $0
            echo -e "\033[1;43m#====================================================#${h}"
            echo -e "\033[1;43m#::  Next you need to execute:                       #${h}"
            echo -e "\033[1;43m#::  arch-chroot /mnt /bin/bash                      #${h}"
            echo -e "\033[1;43m#::  Then you can install the driver or software.。  #${h}"
            echo -e "\033[1;43m#====================================================#${h}"
            sleep 5
            exit 0
        fi

fi
#==========  Installation GRUB ===========3333333333333
if [[ ${tasks} == 3 ]];then
            echo -e "${wg}Installing grub tools.${h}"  #安装grub工具
            pacman -S grub efibootmgr os-prober
            grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archlinux
            grub-mkconfig -o /boot/grub/grub.cfg
            echo -e "${g}:: ==>> Configure enable Network.${h}"      #配置网络
            systemctl enable NetworkManager &> /dev/null    #
                if efibootmgr | grep "Archlinux" &> /dev/null ; then
                    echo -e "${g} Grub installed successfully -=> [Archlinux] ${h}"
                    echo -e "${g}     `efibootmgr | grep "Archlinux"`  ${h}"
                else
                    echo -e "${r} Grub installed failed ${h}"
                    echo -e "${g}     `efibootmgr`  ${h}"

            echo -e "\033[1;43m#====================================================#${h}"
            echo -e "\033[1;43m#::  Next you need to execute:                       #${h}"
            echo -e "\033[1;43m#::  arch-chroot /mnt /bin/bash                      #${h}"
            echo -e "\033[1;43m#::  Then you can install the driver or software.。  #${h}"
            echo -e "\033[1;43m#====================================================#${h}"
            sleep 10
            exit 0
        fi

fi

 #           echo "准备chroot 进入到新系统"
#            cp ${LIST_IN} /mnt/root
#            arch-chroot /mnt /bin/bash
 #           ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime



#    
#   
#   vim /etc/locale.gen
#        en_US.UTF-8 UTF-8
#        zh_CN.UTF-8 UTF-8
#    locale-gen
#    echo "LANG=en_US.UTF-8" > /etc/locale.conf  #系统语言（英文）
#    echo "Archlinux" > /etc/hostname
#    passwd
#    pacman -S xf86-input-libinput xf86-input-synaptics     #触摸板驱动
#    sudo pacman -S create_ap   #无线AP
#        pacman -S mesa-libgl xf86-video-intel libva-intel-driver libvdpau-va-glmesa-demos    #intel
#    pacman -S nvidia nvidia-settings xf86-video-nv   #英伟达
#    pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils mesa #图像界面安装
#    echo "LANG=zh_CN.UTF-8" > /etc/locale.conf  #系统语言（中文）
#    pacman -S alsa-utils pulseaudio pulseaudio-alsa  #安装声音软件包     
#    sudo pacman -S ttf-dejavu wqy-zenhei wqy-microhei ttf-liberation ttf-dejavu #字体

#    useradd -m -g users -G wheel -s /bin/bash kendeya
#    passwd kendeya
#    %wheel ALL=(ALL) NOPSSWD: ALL    sudo  

	

 

#
##========退出 EXIT
case $principal_variable in
    q | Q | quit | QUIT)
    clear;
    echo;
    echo -e "${wg}#----------------------------------#${h}"
    echo -e "${wg}#:: script is over. Thank.         #${h}"
    echo -e "${wg}#----------------------------------#${h}"
    
    exit 0
esac

# head -n 10 /etc/profile
# tail  -n 5 /etc/profile
