#!/bin/bash
#========变量值
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
#========网络变量
ETHERNET=`ip link | grep 'enp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`  #有线
WIFI=`ip link | grep 'wlp[0-9]s[0-9]' | grep -v 'grep' | awk '{print $2}' | cut -d":" -f1`   #无线
#WIFI_IP=`ifconfig ${WIFI} &> $null || echo "--.--.--.--" && ifconfig ${WIFI} | grep ./a"inet " |  awk '{print $2}'`
#ETHERNET_IP=`ifconfig ${ETHERNET} &> $null || echo "--.--.--.--" && ifconfig ${ETHERNET} | grep "inet " |  awk '{print $2}'`

ETHERNET_IP=`ip route | grep "${ETHERNET}" &> ${null} && ip route list | grep "${ETHERNET}" | cut -d" " -f9 | sed -n '2,1p'`  
WIFI_IP=`ip route | grep ${WIFI} &> ${null} && ip route list | grep ${WIFI} |  cut -d" " -f9 | sed -n '2,1p'`

#========Arch 源'
region='## China'
ustc='Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch'
netease='Server = https://mirrors.163.com/archlinux/$repo/os/$arch'
tsinghua='Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch'
mirrorlist='/etc/pacman.d/mirrorlist'
sedname=`sed -n '7,1p' $mirrorlist`
sedserver=`sed -n '8,1p' ${mirrorlist}`
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
h='\033[0m'		 #---后缀
bx='\033[1;4;36m' #---蓝 下划线
sp=" "
#No_IP_Addess=" "
wy='\033[1;41m' h='\033[0m'
#========选项
echo -e "#=======================================================#"
echo -e "# ${b}Script Name:        Arch Linux Script${h}"  
echo -e "# ${b}Author:             Basierl${h}"
echo -e "# ${b}GitHub:	      ${bx}https://github.com/BaSierL/arch_install${h}"
echo -e "# ${g}Ethernet:           ${ETHERNET_IP:-No_network}${h}"
echo -e "# ${g}WIFI:	              ${WIFI_IP:-No_network}${h}"
echo -e "# ${g}SSH:                ssh root@${ETHERNET_IP:-IP_Addess}${h}"
echo -e "# ${g}SSH:                ssh root@${WIFI_IP:-IP_Addess}${h}"
echo -e "#=======================================================#"
echo;
echo -e "${w}:: ==>> Configure Mirrorlist   [1]${h}"
echo -e "${w}:: ==>> Configure Network      [2]${h}"
echo -e "${w}:: ==>> Install Systemctl      [3]${h}"
echo -e "${w}:: ==>> Configure SSH          [4]${h}"
echo -e "${w}:: ==>> Exit Script            [Q]${h}"
echo;
echo -e "\033[1;33m:: ==>> What are the tasks[1,2,3..]? ${h}"
read -p ':: ==>> : ' principal_variable
#
#========ArchLinux Mirrorlist
echo;
if [[ ${principal_variable} == 1 ]]; then
    read -p ":: ==>> Tsinghua(https)[1] 163(https)[2] Ustc(https)[3] Query[4] Exit[4]?: " mirror_variable
        case $mirror_variable in
            1)      
                echo;
                sed -i "s@$sedname@$region@" ${mirrorlist}
                sed -i "s@$sedserver@$tsinghua@" ${mirrorlist}
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
                sed -i "s@$sedserver@$netease@" ${mirrorlist}
                sed -n '7,8p' ${mirrorlist}
                sleep 3
                echo;
                pacman -Syy || ls /usr/bin/lolcat &> $null && echo "y" |  pacman -S lolcat 
                echo;
                echo;
                bash ${LIST_IN}
                ;;
            3)
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
            4)
                head -n 8 ${mirrorlist}
                echo;
                echo;
                sleep 3
                bash ${LIST_IN}
                ;;
            5) 
                bash ${LIST_IN}
                ;;
        esac
fi
#========检查网络  2
if [[ ${principal_variable} == 2 ]]; then
    echo;
    echo ":: Checking the currently available network."
    sleep 2
    echo -e ":: Ethernet: ${r}${ETHERNET}${h}" 2> $null
    echo -e ":: Wifi:   ${r}${WIFI}${h}" 2> $null 
read -p ":: ==>> Query Network: Ethernet[1] Wifi[2] Configure[3] Exit[4]?: " wlink
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
        read -p ":: Configure Network WIFI[1] ETHERNET[2]?: " SNET
            case ${SNET} in
                1) 
                    echo ":: 请稍等！"
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
##========开启SSH 4
if [[ ${principal_variable} == 4 ]]; then
    ls /usr/bin/ssh &> $null && echo "Install Openssh" ||  echo "y" |  pacman -S openssh 
    systemctl start sshd.service  &> $null
    netstat -antp | grep sshd
    echo;
    echo ":: 正在设置密码."
    echo ${USER}:${PASS} | chpasswd &> $null
    clear
    echo -e "\033[1;42m#=================================#${h}"
    echo -e "\033[1;42m#:: User: ${USER}                    #${h}"
    echo -e "\033[1;42m#:: Password: ${PASS}              #${h}"
    echo -e "\033[1;42m#=================================#${h}"
    echo;
    bash ${LIST_IN}
fi

##======== 安装ArchLinux 3 ==========================================
if [[ ${principal_variable} == 3 ]];then
#
    echo
    echo -e "${r}      Install System Modular${h}"
    echo "-----------------------------------"
    echo -e "${w}:: ==>> Disk paertition        [1]${h}"
    echo -e "${w}:: ==>> Install System Files   [2]${h}"
    echo -e "${w}:: ==>> Installation Drive     [3]${h}"
    echo "-----------------------------------"
echo;
    echo -e "\033[1;33m:: ==>> What are the tasks[1,2,3..] Exit [Q]? ${h}"
    read -p ':: ==>> : ' tasks
#
#==========磁盘分区==========
        if [[ ${tasks} == 1 ]];then
        #===显示分区 1
            DEV='/dev/'
            sleep 1
            ls /sys/firmware/efi/efivars &> /dev/null && echo -e "\033[1;42mThe system is based on UEFI Pattern.${h}" || echo -e "\033[1;44mThe system is based on BIOS is CSM Pattern.${h}" 
            echo -e "\033[1;42mYou have the following Disks/Partition: ${h}"
            lsblk | grep -v "loop0\|sr0\|NAME"
        #===cfdisk分区工具   
            read -p ':: Note Tips You need to install to that Disk: ( Tips:sda,sdb.... ) : '  BEPA
            [[ $BEPA == sd? && nvme* ]] && cfdisk $DEV$BEPA
        #===/分区
            clear;
            lsblk | grep -v "loop0\|sr0\|NAME"
            read -p ':: Note Tips Root( / )Partition( Tips:sda1,sda2.. | Enter)Skip ) :' GDISK
            [[ $GDISK == sd? && nvme* ]] || mkfs.ext4 $DEV$GDISK
            GDISK_UUID=`ls -l /dev/disk/by-uuid  | grep "$GDISK" | cut -d" " -f11`

            mount $DEV$GDISK /mnt 
            mkdir -p /mnt/boot/EFI
            mkdir -p /mnt/home 
        #===EFI分区
            lsblk | grep -v "loop0\|sr0\|NAME"
            read -p ':: Note Tips EFI Partition :( Tips:sda1,sda2.. | Enter)Skip ) :' EFIDISK
            [[ $EFIDISK == sd? && nvme* ]] || mkfs.vfat $DEV$EFIDISK
            EFIDISK_UUID=`ls -l /dev/disk/by-uuid  | grep "$EFIDISK" | cut -d" " -f11`
            mount $DEV$EFIDISK /mnt/boot/efi &> $null
        #===Home分区
            lsblk | grep -v "loop0\|sr0\|NAME"
            read -p ':: Note Tips Home Partition :( Tips:sda1,sda2.. | Enter)Skip ) :' HDISK
            [[ $HDISK == sd? && nvme* ]] || mkfs.ext4 $DEV$HDISK
            HDISK_UUID=`ls -l /dev/disk/by-uuid  | grep "$HDISK" | cut -d" " -f11`
            mount $DEV$HDISK /mnt/home &> $null
        #===Swap分区
            lsblk | grep -v "loop0\|sr0\|NAME"
            read -p ':: Note Tips Swap Partition :( Tips:sda1,sda2.. | Enter)Skip ) :' SDISK
            [[ $SDISK == sd? && nvme* ]] || mkswap $DEV$SDISK && swapon $DEV$SDISK
            clear;
            lsblk | grep -v "loop0\|sr0\|NAME"
            bash ${LIST_IN}
        fi 
#
#========== 安装及匹配系统文件 ==========
        if [[ ${tasks} == 2 ]];then
            echo -e "\033[1;42mUpdate the system clock.${h}"  #更新系统时间
            timedatectl set-ntp true
            sleep 2
            echo;
            echo -e ":: ${r}Install the base packages.${h}"   #安装基本系统
            echo;
            pacstrap -i /mnt base base-devel linux ntfs-3g grub efibootmgr vim  git
	    sleep 2
            echo -e ":: ${r}Configure Fstab File.${h}" #配置Fstab文件
	    genfstab -U /mnt >> /mnt/etc/fstab
            sleep 2
            clear
            echo
            cp -rf ${LIST_IN} /mnt/root &> $null
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
if [[ ${principal_variable} == q || Q || quit || QUIT ]];then
    clear;
    echo;
    echo -e "\033[1;42m#----------------------------------#${h}"
    echo -e "\033[1;42m#:: script is over. Thank.         #${h}"
    echo -e "\033[1;42m#----------------------------------#${h}"
    /usr/bin/zsh
    exit 0
fi

# head -n 10 /etc/profile
# tail  -n 5 /etc/profile
