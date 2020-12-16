#!/bin/bash
# Author: Auroot/BaSierl
# Wechat：Auroot
# Arch Image: archlinux-2020.12.01-x86_64.iso [2020.10.1 - 2020.12.1]
# URL Blog  : www.auroot.cn 
# URL GitHub: https://github.com/BaSierL/arch_install.git
# URL Gitee : https://gitee.com/auroot/arch_install.git
# Home URL: : https://www.auroot.cn
# 写得可能很潦草 但是能完成我所需要达成的任务；
# set -x
function Init_Global_Variable(){
    # The contents of the variable are customizable
    Version="Arch Linux System installation script V4.0.5"
    Stript_Dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )
    Module="${Stript_Dir}/Module" # The script module directory
    Temp_Data="${Stript_Dir}/Temp_Data" # 日志目录 Log Directory
    # NetworkManager_Pkg="./Pkg/NetworkManager"  # Wifi需要的NetworkManager等包定位
    Install_Log="./Temp_Data/Arch_install.log" # The script log address
    Configure_file="$Module/install.conf"
    Configure_tmp_list="$Temp_Data/auin.list"
    #-------模块链接
    # Default settings
    Branch="master"  # master: 稳定 preview: 测试
    Auroot_Git=${Auroot_Git:-https://gitee.com/auroot/Arch_install/raw/${Branch}}
    Auroot_Module=${Auroot_Module:-$Auroot_Git/Module}
    Mirrorlist_Module=${Mirrorlist_Module:-${Auroot_Module}/mirrorlist.sh}
    Wifi_Module=${Wifi_Module:-${Auroot_Module}/Wifi_Connect.sh}
    Useradd_Module=${Useradd_Module:-${Auroot_Module}/useradd.sh}
    # Log_Module=${Log_Module:-curl -fsSL ${Auroot_Module}/log.sh}
}
function System_Config_Global_Variable(){ 
    Area="/Asia/Shanghai"  # The area.
    PASS="123456"  # SSH password
    Ct_log "function System_Config_Variable"
}
function Desktop_Package_Variable(){
    # 安装包，默认预设 请不要改变量名（萌新）可以自己添加包
    # Font Package.
    Fonts_pkg="wqy-microhei wqy-zenhei ttf-dejavu ttf-ubuntu-font-family noto-fonts noto-fonts-extra noto-fonts-emoji noto-fonts-cjk ttf-dejavu ttf-liberation ttf-wps-fonts"
    # 常用软件 wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn netease-cloud-music deepin-wine-wechat
    Common_pkg="thunar neofetch unrar unzip p7zip zsh vim git mtpfs mtpaint libmtp kchmviewer file-roller yay openssh"
    # Desktop environment Package.
    XorgGroup_pkg="xorg xorg-server xorg-xinit mesa pamac gwenview flameshot"
    Plasma_pkg="$XorgGroup_pkg plasma plasma-meta plasma-desktop konsole dolphin dolphin-plugins kate plasma-pa kio-extras powerdevil kcm-fcitx ark"
    Gnome_pkg="$XorgGroup_pkg gnome gnome-extra gnome-tweaks gnome-shell gnome-shell-extensions gvfs-mtp gvfs gvfs-smb gnome-keyring"
    Deepin_pkg="$XorgGroup_pkg deepin deepin-extra lightdm-deepin-greeter"
    Xfce4_pkg="$XorgGroup_pkg xterm xfce4 xfce4-goodies light-locker xfce4-power-manager libcanberra"
    i3wm_pkg="$XorgGroup_pkg i3-wm i3lock i3blocks i3status rxvt-unicode compton dmenu feh picom nautilus polybar gvfs-mtp xfce4-terminal termite"
    i3gaps_pkg="$XorgGroup_pkg i3-gaps i3lock i3blocks i3status rxvt-unicode compton dmenu feh picom nautilus polybar gvfs-mtp xfce4-terminal termite"
    mate_pkg="$XorgGroup_pkg mate mate-extra lightdm lightdm-gtk-greeter xorg-server"
    lxde_pkg="$XorgGroup_pkg lxde" 
    Cinnamon_pkg="$XorgGroup_pkg cinnamon blueberry gnome-screenshot gvfs gvfs-mtp gvfs-afc exfat-utils faenza-icon-theme accountsservice gnoem-terminal"
    Ct_log "function Desktop_Package_Variable"
}
function Boot_Package_Variable(){ # Boot Pkg
    Bios_grub_Pkg="grub os-prober networkmanager"
    Uefi_grub_Pkg="grub efibootmgr os-prober networkmanager"
    Ct_log "function Boot_Package_Variable"
}
function Driver_Package_Variable(){
    # Driver Package.
    AudioDriver_Pkg="alsa-utils pulseaudio pulseaudio-bluetooth pulseaudio-alsa"
    inputDriver_Pkg="xf86-input-synaptics xf86-input-libinput create_ap"
    BluetoothDriver_Pkg="bluez bluez-utils blueman bluedevil"
    Intel_Pkg="xf86-video-intel intel-ucode xf86-video-intel xf86-video-intel mesa-libgl libva-intel-driver libvdpau-va-gl"
    Amd_Pkg="amd-ucode"
    Nvidia_A_Pkg="nvidia nvidia-utils opencl-nvidia lib32-nvidia-utils lib32-opencl-nvidia mesa lib32-mesa-libgl"
    Nvidia_B_Pkg="optimus-manager optimus-manager-qt"
    Ct_log "function Driver_Package_Variable"
}
function Color_Global_Variable(){
    #-------脚本颜色变量
    r='\033[1;31m'  #---红
    g='\033[1;32m'  #---绿
    y='\033[1;33m'  #---黄
    b='\033[1;36m'  #---蓝
    w='\033[1;37m'  #---白
    h='\033[0m'     #---后缀
    #-----------------------------#
    rw='\033[1;41m'  #--红白
    wg='\033[1;42m'  #--白绿
    ws='\033[1;43m'  #--白褐
    wb='\033[1;44m'  #--白蓝
    wq='\033[1;45m'  #--白紫
    wa='\033[1;46m'  #--白青
    # bx='\033[1;4;36m'  #---蓝 下划线
    #-----------------------------#
    # 交互 蓝  红
    JHB=$(echo -e "${b}-=>${h} "); # JHR=$(echo -e "${r}-=>${h} ")
    # 交互 绿 黄
    JHG=$(echo -e "${g}-=>${h} "); JHY=$(echo -e "${y}-=>${h} ")
    #-----------------------------
    # 提示 蓝 红
    PSB=$(echo -e "${b} ::==>${h}"); PSR=$(echo -e "${r} ::==>${h}")
    # 提示 绿 黄
    PSG=$(echo -e "${g} ::==>${h}"); PSY=$(echo -e "${y} ::==>${h}")
}
#-----------自检
function facts(){
    #------检查必要目录或文件是否存在
    if [ ! -d "${Temp_Data}" ]; then
        mkdir -p "${Temp_Data}"
    fi
    if [ ! -d "${Module}" ]; then
        mkdir -p "${Module}"
    fi
    if [ ! -e "${Install_Log}" ]; then
        touch "${Install_Log}"
    fi
    if [ ! -e "${Configure_tmp_list}" ]; then
        touch "${Configure_tmp_list}"
        echo "# This is not a profile." > "$Configure_tmp_list"
        echo "# Do not change one of the items." >> "$Configure_tmp_list"
        cat > "$Configure_tmp_list"<< EOF
# This is not a profile.
# Do not change one of the items.
Disk=
Bios_partition=
Root_partition=
Swap_file=
Swap_size=
Pattern=
Users=
Password=
Root_Password=
Archiso_Version_check=
Bios_Type=
Bisk_Type=
CPU_Vendor=
Virtualization=
EOF
    fi
    # boot
    if [ -d /sys/firmware/efi ]; then
        Bios_Type="Uefi"
        Bisk_Type="gpt"
        sed -i "13c Bios_Type=Uefi" "$Configure_tmp_list"
        sed -i "14c Bisk_Type=gpt" "$Configure_tmp_list"
    else
        Bios_Type="Bios"
        Bisk_Type="dos"
        sed -i "13c Bios_Type=Bios" "$Configure_tmp_list"
        sed -i "14c Bisk_Type=dos/mbr" "$Configure_tmp_list"
    fi
    if [ -n "$(lscpu | grep GenuineIntel)" ]; then
        CPU_Vendor="intel"
        sed -i "15c CPU_Vendor=intel" "$Configure_tmp_list"
    elif [ -n "$(lscpu | grep AuthenticAMD)" ]; then
        CPU_Vendor="amd"
        sed -i "15c CPU_Vendor=amd" "$Configure_tmp_list"
    fi
    # Virtualization
    if [ -n "$(lspci | grep -i virtualbox)" ]; then
        Virtualization="virtualbox"
        sed -i "16c Virtualization=virtualbox" "$Configure_tmp_list"
    elif [ -n "$(lspci | grep -i vmware)" ]; then
        Virtualization="vmware"
        sed -i "16c Virtualization=vmware" "$Configure_tmp_list"
    fi
    # 判断当前模式
    if [ -e /Temp_Data/Chroot ]; then
        ChrootPattern=$(echo -e "${g}Chroot-ON${h}")
        sed -i "8c Pattern=Chroot-ON" "$Configure_tmp_list"
    else
        ChrootPattern=$(echo -e "${r}Chroot-OFF${h}")
        sed -i "8c Pattern=Chroot-OFF" "$Configure_tmp_list" 
    fi
    # 检验Archiso是否最新
    Query_Archiso_Version_check=$(Query_List _Templist_ Archiso_Version_check)
    if [ "$Query_Archiso_Version_check" = "no" ]; then
        Archiso_Version_check 
    fi
    ln -sf /usr/share/zoneinfo"$Area" /etc/localtime &>/dev/null && hwclock --systohc
}
# 查询列表
function Query_List(){
    List_options=${1}
    List_Query=${2}
    case ${List_options} in
        _Config_)
            Temp_list=$(cat "$Configure_file")
        ;;
        _Templist_)
            Temp_list=$(cat "$Configure_tmp_list")
        ;;
    esac 
    for i in ${Temp_list[*]}; do
        if [[ "$i" =~ $List_Query ]]; then
            echo "$i" | cut -d"=" -f2
        fi 
    done
    Ct_log "function Query_List"
}
# 检查必要文件是否存在
function Update_Module(){
    if [ ! -e "$Module/mirrorlist.sh" ]; then
        curl -fsSL "$Auroot_Module/mirrorlist.sh" > "${Module}/mirrorlist.sh" 
        chmod +x "$Module/mirrorlist.sh"
    fi
    if [ ! -e "$Module/useradd.sh" ]; then
        curl -fsSL "$Auroot_Module"/useradd.sh > "${Module}/useradd.sh"
        chmod +x "$Module/useradd.sh"
    fi
    if [ ! -e "$Module/Process_manage.sh" ]; then
        curl -fsSL "$Auroot_Module"/Process_manage.sh > "${Module}/Process_manage.sh"
        chmod +x "$Module/Process_manage.sh"
    fi
    # if [ ! -e ${Module}/Wifi_Connect.sh ]; then
    #     curl -fsSL "$Auroot_Module"/Wifi_Connect.sh > ${Module}/Wifi_Connect.sh
    #     chmod +x ${Module}/Wifi_Connect.sh
    # fi
    if [ ! -e "${Configure_file}" ]; then
        curl -fsSL "$Auroot_Git"/install.conf > "$Configure_file"
    fi
    Ct_log "function Update_Module"
}
# 帮助文档
function help(){
    echo "${Version}"
    echo -e "auin is a script for ArchLinux installation and deployment.\n"
    echo -e "usage: auin [-h] [-V] command ...\n"
    echo "Optional arguments:"
    echo "  -m, --mirror   Automatically configure mirrorlist file and exit."
    echo "  -w, --cwifi    Connect to a WIFI and exit."
    echo "  -s, --openssh  Open SSH service (default password: 123456) and exit."
    echo "  -vm --virtual  Install Vmware/Virtualbox Tools and exit."
    echo "  -L, --log      print log file and exit."
    echo "  -h, --help     Show this help message and exit. "
    echo "  -V, --version  Show the conda version number and exit."
}
function Auin_Options(){
    Function_Enter="${1}"
    case ${Function_Enter} in
        -m | --mirror)
            bash "${Module}/mirrorlist.sh"
            exit 0;
        ;;
        -w | --cwifi)
            # bash ${Module}/Wifi_Connect.sh ${NetworkManager_Pkg} "${Temp_Data}"
            Configure_wifi
            exit 0;
        ;;
        -s | --openssh)
            Open_SSH;
            exit 0;
        ;;
        -vm )
            install_virtualization_service
        ;;
        -L | --log)
            more "${Install_Log}"
            exit 0;
        ;;
        -h | --help)
            help
            exit 0;
        ;;
        -v | -V | --version)
            clear;
            version
            exit 0;
        ;;
        -shell)
            Shell_Exec
        ;;
    esac
}
# 脚本版本
function version(){
    echo -e "${wg}${Version}${h}"
    echo -e "${wa}Author:${h} Auroot/BaSierl"
    echo -e "${rw}blog  :${h} www.auroot.cn"
    echo -e "${wq}URL Github:${h} https://github.com/BaSierL/arch_install.git"
    echo -e "${wb}URL Gitee :${h} https://gitee.com/auroot/arch_install.git"
}
# 网络变量
function Info_Ethernet(){
    for  ((Cycle_number=3;Cycle_number<=10;Cycle_number++)); do
        Info_Nic=$(cut -d":" -f1 /proc/net/dev | sed -n "$Cycle_number",1p | sed 's/^[ ]*//g')
        if [ -n "$(echo "$Info_Nic" | grep -i "en")" ]; then 
            Ethernet_Name="$Info_Nic"
            Ethernet_ip=$(ip route list | grep "${Ethernet_Name}" | cut -d" " -f9 | sed -n '2,1p')
        elif [ -n "$(echo "$Info_Nic" | grep -i "wl")" ]; then
            Wifi_Name="$Info_Nic"
            Wifi_ip=$(ip route list | grep "${Wifi_Name}" | cut -d" " -f9 | sed -n '2,1p') 
        fi
    done    
    Ct_log "function Info_Ethernet"
}
#  wifi配置
function Configure_wifi() {
    Output_WIFI_SSID=$(echo -e "${PSG} ${g} Wifi SSID 'TP-Link...' :${h} ${JHB}")
    Output_WIFI_PASS=$(echo -e "${PSG} ${g} Wifi Password :${h} ${JHB}")
    read -p "${Output_WIFI_SSID}" WIFI_SSID
    read -p "${Output_WIFI_PASS}" WIFI_PASSWD
    iwctl --passphrase "$WIFI_PASSWD" station "$Wifi_Name" connect "$WIFI_SSID"
    sleep 2;
    # only on ping -c 1, packer gets stuck if -c 5
    ping -c 1 -i 2 -W 5 -w 30 8.8.8.8
    if [ $? -ne 0 ]; then
        echo "Network ping check failed. Cannot continue."
        Process_Management stop "$0"
    fi
    Ct_log "function Configure_wifi"
}
# 连接有线网络
function Configure_Ethernet(){
    echo ":: One moment please............"
    ls /usr/bin/ifconfig &>/dev/null  echo ":: Install net-tools" ||  echo "y" |  pacman -Syu --noconfirm --needed net-tools
    ip link set "${ETHERNET}" up
    ifconfig "${ETHERNET}" up  
    ping -c 1 -i 2 -W 5 -w 30 8.8.8.8
    Ct_log "function Configure_Ethernet"
    sleep 1;
}

# 开启SSH远程连接
function Open_SSH(){
    echo
    echo -e "${y}:: Setting SSH Username / password.${h}" && Ct_log "echo -e ":: Setting SSH Username / password.""
    echo "${USER}:${PASS}" | chpasswd &>/dev/null && Ct_log "echo ""$USER":"$PASS"" | chpasswd &>/dev/null"
    echo -e "${g} ||=================================||${h}"
    echo -e "${g}       $ ssh $USER@${Ethernet_ip:-IP_Addess..}  ${h}" 
    echo -e "${g}       $ ssh $USER@${Wifi_ip:-IP_Addess..}      ${h}"
    echo -e "${g}       Username --=>  $USER           ${h}"
    echo -e "${g}       Password --=>  $PASS           ${h}"
    echo -e "${g} ||=================================||${h}"
    systemctl start sshd.service && Ct_log "systemctl start sshd.service"
    netstat -antp | grep sshd && Ct_log "netstat -antp | grep sshd"
    Ct_log "function Open_SSH"
}
# 设置root密码 用户  判断/etc/passwd文件中最后一个用户是否大于等于1000的普通用户，如果没有请先创建用户
function ConfigurePassworld(){
    UserName=$(Query_List _Templist_ Users) 
    if [ "${UserName}" != "" ]; then   #  设定一个文件匹配，这个文件在不在都无所谓
        PasswdFile="/etc/passwd"
        for ((Number=1;Number<=50;Number++))  # 设置变量Number 等于1 ；小于等于50 ； Number 1+1直到50
        do
        Query=$(tail -n "${Number}" "${PasswdFile}" | head -n 1 | cut -d":" -f3)
            for Contrast in {1000..1100}
            do
                if [[ $Query -eq $Contrast ]]; then
                    CheckingUsers=$(grep "$Query" < ${PasswdFile} | cut -d":" -f1)
                    CheckingID=$(grep "$Query" < ${PasswdFile} | cut -d":" -f3)
                fi
            done 
        done
        # sed -i "9c Users=${heckingUsers}" $Configure_tmp_list 
        echo -e "${PSG} ${g}A normal user already exists, The UserName:${h} ${b}${CheckingUsers}${h} ${g}ID: ${b}${CheckingID}${h}." 
        sleep 2;
    else
        bash "${Module}/useradd.sh" "${Temp_Data}"
        UserName=$(Query_List _Templist_ Users) 
        echo -e "${PSG} ${g}A normal user already exists, The UserName:${h} ${b}${UserName}${h}." 
        sleep 2;
    fi
    Ct_log "function ConfigurePassworld"
}
#  安装系统 内核等包
function Install_Archlinux(){
    echo -e "${wg}Update the system clock.${h}"   # update time
    timedatectl set-ntp true
    sleep 2;
    echo -e "\n${PSG} ${g}Install the base packages.${h}\n"
    pacstrap -i /mnt linux base base-devel linux-firmware linux-headers ntfs-3g networkmanager net-tools vim #  linux base 
    sleep 2;
    echo -e "\n${PSG}  ${g}Configure Fstab File.${h}"   # Configure fstab file
    genfstab -U /mnt >> /mnt/etc/fstab  

    cp -rf "${Temp_Data}" "/mnt/" 
    cp -rf "${Module}" "/mnt" 
    cp -rf "${Configure_file}" "/mnt/Temp_Data" 
    cp -rf "${Configure_tmp_list}" "/mnt/Module" 

    cat "$0" > /mnt/auin.sh  && chmod +x /mnt/auin.sh 
    
    touch /mnt/Temp_Data/Chroot && echo "Chroot=ON" > /mnt/Temp_Data/Chroot
    Ct_log "function Install_Archlinux"
}
# Chroot
function Auin_chroot(){    
    arch-chroot /mnt /bin/bash -c "/auin.sh"
}
# 字体安装
function Install_Font(){
    In_font=$(echo -e "${PSG} ${y}Whether to install the Font. Install[y] No[*]${h} ${JHB}")
    read -p "${In_font}" UserInf_Font
    case ${UserInf_Font} in
        [Yy]*)
            pacman -Syu --noconfirm --needed $Fonts_pkg # install Fonts pkg
        ;;
    esac
    Ct_log "function Install_Font"
}
# 安装常用包函数
function CommonPrograms_Install(){
    pacman -Syu --noconfirm --needed $Common_pkg
    Ct_log "function CommonPrograms_Install"
}
# 桌面环境配置函数
function Desktop_Env_Config(){
    systemctl enable "$DESKTOP_MANAGER_NAME"
    Ct_log "systemctl enable ${DESKTOP_MANAGER_NAME}" 
    Configure_Xinitrc
    echo "exec ${DESKTOP_XINIT}" >> /etc/X11/xinit/xinitrc 
    cp -rf /etc/X11/xinit/xinitrc  /home/"$CheckingUsers"/.xinitrc 
    Ct_log "cp -rf /etc/X11/xinit/xinitrc  /home/${CheckingUsers}/.xinitrc "
    echo -e "${PSG} ${w}${DESKTOP_ENVS} ${g}Desktop environment configuration completed.${h}"  
    sleep 2;   # 以下是配置 ohmyzsh
    #sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/install_zsh.sh)"
    Ct_log "function Desktop_Env_Config"
} 
# 打印选项4中的选项
function input_System_Module(){
    echo -e "\n     ${w}***${h} ${r}Install System Module${h} ${w}***${h}  "  
    echo "---------------------------------------------"
    echo -e "${PSY} ${g}   Disk partition.         ${h}${r}**${h}  ${w}[1]${h}"
    echo -e "${PSY} ${g}   Install System Files.   ${h}${r}**${h}  ${w}[2]${h}"
    echo -e "${PSG} ${g}   Installation Drive.     ${h}${b}*${h}   ${w}[21]${h}"    
    echo -e "${PSG} ${g}   Installation Desktop.   ${h}${b}*${h}   ${w}[22]${h}"  
    echo -e "${PSY} ${g}   Configurt System.       ${h}${r}**${h}  ${w}[23]${h}"
    echo -e "${PSY} ${g}   Install virtual tools.  ${h}${b}*${h}   ${w}[24]${h}"  # 引用 https://gitee.com/Edward_Elric/archinstallscript/blob/master/Arch_install.sh +247行
    echo -e "${PSY} ${g}   arch-chroot /mnt.       ${h}${r}**${h}  ${w}[0]${h}"
    echo -e "---------------------------------------------\n"
}
function input_Desktop_env(){
    echo -e "\n     ${w}***${h} ${b}Install Desktop${h} ${w}***${h}  "  
    echo "---------------------------------"
    echo -e "${PSB} ${g}   KDE plasma.     ${h}${w}[1]${h}  --sddm"
    echo -e "${PSB} ${g}   Gnome.          ${h}${w}[2]${h}  --gdm"
    echo -e "${PSB} ${g}   Deepin.         ${h}${w}[3]${h}  --lightdm"    
    echo -e "${PSB} ${g}   Xfce4.          ${h}${w}[4]${h}  --lightdm"  
    echo -e "${PSB} ${g}   i3wm.           ${h}${w}[5]${h}  --sddm"
    echo -e "${PSB} ${g}   i3gaps.         ${h}${w}[6]${h}  --lightdm"
    echo -e "${PSB} ${g}   lxde.           ${h}${w}[7]${h}  --lxdm"
    echo -e "${PSB} ${g}   Cinnamon.       ${h}${w}[8]${h}  --lightdm"
    echo -e "${PSB} ${g}   Mate.           ${h}${w}[9]${h}  --lightdm"
    echo -e "---------------------------------\n"                           
}
function partition_facts(){
    disk_options=${1}
    disk_name=${2}
    case ${disk_options} in
        _partition_)
            State="false"
            if echo "${disk_name}" | cut -d"/" -f3 | grep -E "^[a-z]d[a-z]$|^nvme|^mmc" &>/dev/null  ; then
                userinput_disk=$(echo "${disk_name}" | cut -d"/" -f3 | grep -E "^[a-z]d[a-z]$|^nvme|^mmc")
                State="true"
            else
                State="false"
            fi
        ;;
        _partition_root_)
            State="false"
            if echo "${disk_name}" | cut -d"/" -f3 | grep -E "^[a-z]d[a-z][1-9]|^nvme*|^mmc*" &>/dev/null  ; then
                userinput_disk=$(echo "${disk_name}" | cut -d"/" -f3 | grep -E "^[a-z]d[a-z][1-9]|^nvme*|^mmc*")
                State="true"
            else
                State="false"
            fi
        ;;
        _Bisk_Type_)
            user_Bisk_Type=$(fdisk -l /dev/"$userinput_disk" | grep "Disklabel type:")
            if [ -n "$(echo "$user_Bisk_Type" | grep "gpt")" ]; then
                user_Bisk_Type="gpt"
            elif [ -n "$(echo "$user_Bisk_Type" | grep "dos")" ]; then
                user_Bisk_Type="dos"
            elif [ -n "$(echo "$user_Bisk_Type" | grep "sgi")" ]; then
                user_Bisk_Type="sgi"
            elif [ -n "$(echo "$user_Bisk_Type" | grep "sun")" ]; then
                user_Bisk_Type="sun"
            else
                user_Bisk_Type="false"
            fi
        ;;
    esac
    Ct_log "function partition_facts"
}
function partition_type(){
    partition_facts _Bisk_Type_ "$input_disk"
    lsblk | grep -E "^[a-z]d[a-z]|^nvme|^mmc"|grep -v "grep" 
    echo;
    if [[ "$user_Bisk_Type" != "$Bisk_Type" ]] ; then
        echo -e "$PSR ${r} The boot does not match the disk ${b}[$Bios_Type] ${r}not ${b}[$user_Bisk_Type]$h${r}.$h"
        partition_type_output=$(echo -e "\n$PSY ${y}Whether to convert Disklabel type ->${b}[$Bisk_Type]${y}? [y/N]:$h $JRY")
        read -p "${partition_type_output}" user_input
        case "$user_input" in
            [Yy]*)
                if [[ "$Bisk_Type" = "gpt" ]] ; then
                    Bisk_Type="gpt"
                elif [[ "$Bisk_Type" = "dos" ]] ; then
                    Bisk_Type="msdos"   
                fi
                parted /dev/"$userinput_disk" mklabel "$Bisk_Type" -s
            ;;
            [Nn]*)
                echo -e "\n$PSR ${r} Error: Disklabel type${b}[$user_Bisk_Type] ${r}not match and cannot be install System.$h"
                Process_Management stop "$0"
        esac 
    else 
        echo -e "\n${PSG} ${g}Currently booted with ${b}[${Bios_Type}]. ${g}Select disk type: ${b}[${Bisk_Type}].${h}"
    fi 
    Ct_log "function partition_type"
}
# 分区
function partition(){
    echo;lsblk -o+UUID | grep -E "sd.|nvme|mmc"    # 显示磁盘
    partition_output=$(echo -e "\n${PSY} ${y}Select disk: ${g}/dev/sdX | sdX ${h}${JHB}")
    read -p "${partition_output}"  input_disk  #给用户输入接口
    partition_facts _partition_ "$input_disk"
    partition_type
    if [[ "$State" = "true" ]] ; then    
        cfdisk "/dev/$userinput_disk" && sed -i "3c Disk=/dev/$userinput_disk" "$Configure_tmp_list"
    else
        echo -e "\n${PSR} ${r} [cfdisk] Error: Please input: /dev/sdX | sdX? !!! ${h}"  
        Write_log_error "[cfdisk] Please input: /dev/sdX | sdX? !!!"
        Process_Management stop "$0"
    fi
    Ct_log "function partition"
}
function partition_booting(){
    echo;lsblk -o+UUID | grep -E "sd.|nvme|mmc|mmc" | grep -E "sd.|nvme|mmc"  
    Output_booting=$(echo -e "\n${PSY} ${y}Choose your EFI / BOOT partition: ${g}/dev/sdX[0-9] | sdX[0-9] ${h}${JHB}")
    read -p "${Output_booting}" input_booting   #给用户输入接口
        #设置输入”/dev/sda” 或 “sda” 都输出为 sda
        partition_facts _partition_root_ "$input_booting"
        if [[ "$State" = "true" ]] ; then
            mkfs.vfat "/dev/$userinput_disk" && Ct_log "mkfs.vfat /dev/$userinput_disk"  
            if [[ "$Bios_Type" = "Uefi" ]] ; then
                mkdir -p /mnt/boot/efi &>/dev/null && Ct_log "mkdir -p /mnt/boot/efi"
                umount -R /mnt/boot/efi 2&>/dev/null
                mount "/dev/$userinput_disk" /mnt/boot/efi 
                Ct_log "mount /dev/$userinput_disk /mnt/boot/efi"
                sed -i "4c Uefi_partition=/dev/$userinput_disk" "$Configure_tmp_list"
            else
                mkdir -p /mnt/boot &>/dev/null && Ct_log "mkdir -p /mnt/boot"
                umount -R /mnt/boot 2&>/dev/null
                mount "/dev/$userinput_disk" /mnt/boot 
                Ct_log "mount /dev/$userinput_disk /mnt/boot "
                sed -i "4c Bios_partition=/dev/$userinput_disk" "$Configure_tmp_list"
            fi
        else
            echo -e "\n${r} ==>> [EFI] Error: Please input: /dev/sdX[0-9] | sdX[0-9] !!! ${h}"  
            Write_log_error "[EFI] Error: Please input: /dev/sdX[0-9] | sdX[0-9] !!!"
            Process_Management stop "$0"
        fi
        Ct_log "function partition_booting"
}
function partition_root(){
    echo;lsblk -o+UUID | grep -E "sd.|nvme|mmc" | grep -E "sd.|nvme|mmc"  
    Output_boot=$(echo -e "\n${PSY} ${y}Choose your root[/] partition: ${g}/dev/sdX[0-9] | sdX[0-9] ${h}${JHB}")
    read -p "${Output_boot}"  input_root   #给用户输入接口
    partition_facts _partition_root_ "$input_root"
    if [[ "$State" = "true" ]] ; then
        mkfs.ext4 "/dev/$userinput_disk" && Ct_log "mkfs.ext4 /dev/$userinput_disk" 
        umount -R /mnt 2&>/dev/null 
        mount "/dev/$userinput_disk" /mnt && Ct_log "mount /dev/$userinput_disk /mnt"
        sed -i "5c Root_partition=/dev/$userinput_disk" "$Configure_tmp_list"
    else
        echo -e "\n${PSR} ${r} [root] Error: Please input: /dev/sdX[0-9] | sdX[0-9] !!! ${h}"  
        Write_log_error "[root] Please input: /dev/sdX[0-9] | sdX[0-9] !!!"
        Process_Management stop "$0"
    fi
    Ct_log "function partition_root"
}
function partition_swap(){
    echo;lsblk -o+UUID | grep -E "sd.|nvme|mmc" | grep -E "sd.|nvme|mmc"  
    Output=$(echo -e "\n${PSY} ${y}lease select the size of swapfile: ${g}[example:256M-10000G ~] ${y}Skip: ${g}[No]${h} ${JHB}")
    read -p "${Output}"  input_swap_size     #用户输入接口
    case ${input_swap_size} in
        [Nn]* )
            echo -e "${wg} ::==>> Partition complete. ${h}"  
            sleep 1
            bash "${0}"
        ;;
        * )
            if echo "$input_swap_size" | grep -E "^[0-9]*[A-Z]$" &>/dev/null ; then
                echo -e "${PSG} ${g}Assigned Swap file Size: ${input_swap_size} .${h}"
                fallocate -l "${input_swap_size}" /mnt/swapfile && Ct_log "fallocate -l ${input_swap_size} /mnt/swapfile" 
                # dd if=/dev/zero of=/mnt/swapfile bs=1M count=$SWAP_SIZE status=progress
                chmod 600 /mnt/swapfile && Ct_log "chmod 600 /mnt/swapfile"
                mkswap /mnt/swapfile && Ct_log "mkswap /mnt/swapfile"
                swapon /mnt/swapfile && Ct_log "swapon /mnt/swapfile"
                sed -i "6c Swap_file=/mnt/swapfile" "$Configure_tmp_list"
                sed -i "7c Swap_size=${input_swap_size}" "$Configure_tmp_list"
            else
                echo;
                echo -e "${PSR} ${r}[SWAP] Error: Please input size: [example:512M-4G ~] !!! ${h}"  
                Write_log_error "[SWAP] Error: Please input size: [example:512M-4G ~] !!!"
                Process_Management stop "$0"
            fi
        ;;
    esac 
    Ct_log "function partition_swap"
}
# 桌面管理选择
# 软件包列表 及 读取变量DESKTOP_MANAGER_NAME,安装桌面/显示管理器  
function Desktop_Manager(){
    echo "---------------------------------"
    echo -e "${PSB} ${g}   sddm.     ${h}${w}[1]${h}"  
    echo -e "${PSB} ${g}   gdm.      ${h}${w}[2]${h}" 
    echo -e "${PSB} ${g}   lightdm.  ${h}${w}[3]${h}"   
    echo -e "${PSB} ${g}   lxdm.     ${h}${w}[4]${h}"  
    echo -e "${PSB} ${g}   default.  ${h}${w}[*]${h}" 
    echo "---------------------------------"
    SELECT_DM=$(echo -e "${PSG} ${y} Please select Desktop Manager: ${h} ${JHB}")
    read -p "${SELECT_DM}" DM_ID
    case ${DM_ID} in
        1)
            DESKTOP_MANAGER_NAME="sddm"
        ;;
        2)
            DESKTOP_MANAGER_NAME="gdm"  
        ;;
        3)
            DESKTOP_MANAGER_NAME="lightdm"
        ;;
        4)
            DESKTOP_MANAGER_NAME="lxdm"
        ;;
        *)
            if [[ $DESKTOP_ENVS == "plasma" ]] ; then
                DESKTOP_MANAGER_NAME="sddm"
            elif [[ $DESKTOP_ENVS == "gnome" ]] ; then
                DESKTOP_MANAGER_NAME="gdm"
            elif [[ $DESKTOP_ENVS == "deepin" ]] ; then
                DESKTOP_MANAGER_NAME="lightdm"
            elif [[ $DESKTOP_ENVS == "xfce" ]] ; then
                DESKTOP_MANAGER_NAME="lightdm"
            elif [[ $DESKTOP_ENVS == "i3wm" ]] ; then
                DESKTOP_MANAGER_NAME="sddm"
            elif [[ $DESKTOP_ENVS == "i3gaps" ]] ; then
                DESKTOP_MANAGER_NAME="lightdm"
            elif [[ $DESKTOP_ENVS == "lxde" ]] ; then
                DESKTOP_MANAGER_NAME="lxdm"
            elif [[ $DESKTOP_ENVS == "cinnamon" ]] ; then
                DESKTOP_MANAGER_NAME="lightdm"
            elif [[ $DESKTOP_ENVS == "mate" ]] ; then
                DESKTOP_MANAGER_NAME="lightdm"  
            fi
        ;;
    esac
    echo ${DESKTOP_MANAGER_NAME} > "${Temp_Data}/Desktop_Manager"
        # IN_SDDM_PKG="sddm sddm-kcm"
        # IN_GDM_PKG="gdm"
        # IN_LIGHTDM_PKG="lightdm"
        # IN_LXDM_PKG="lxdm"
        if [[ ${DESKTOP_MANAGER_NAME} == "sddm" ]] ; then
            pacman -Syu --noconfirm --needed sddm sddm-kcm  #--安装SDDM
            Ct_log "pacman -Syu --noconfirm --needed sddm sddm-kcm"
            Desktop_Env_Config  # 环境配置
        elif [[ ${DESKTOP_MANAGER_NAME} == "gdm" ]] ; then
            pacman -Syu --noconfirm --needed gdm    #--安装GDM
            Ct_log "pacman -Syu --noconfirm --needed gdm"
            Desktop_Env_Config      # 环境配置
        elif [[ ${DESKTOP_MANAGER_NAME} == "lightdm" ]] ; then
            pacman -Syu --noconfirm --needed lightdm lightdm-gtk-greeter  #--安装lightdm
            Ct_log "pacman -Syu --noconfirm --needed lightdm lightdm-gtk-greeter"
            Desktop_Env_Config      # 环境配置
        elif [[ ${DESKTOP_MANAGER_NAME} == "lxdm" ]] ; then
            pacman -Syu --noconfirm --needed lxdm  #--安装LXDM
            Ct_log "pacman -Syu --noconfirm --needed lxdm"
            Desktop_Env_Config      # 环境配置
        fi
    Ct_log "function Desktop_Manager"
}
function desktop_environment_plasma(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1;
    DESKTOP_ENVS="plasma"        
    DESKTOP_XINIT="startkde"      
    pacman -Syu --noconfirm --needed $Plasma_pkg
    CommonPrograms_Install                 
    Desktop_Manager          
    Ct_log "function desktop_environment_plasma"
}
function desktop_environment_gnome(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1;
    DESKTOP_ENVS="gnome"             
    DESKTOP_XINIT="gnome=session"     
    pacman -Syu --noconfirm --needed $Gnome_pkg
    CommonPrograms_Install                     
    Desktop_Manager         
    Ct_log "function desktop_environment_gnome"
}
function desktop_environment_deepin(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1;
    DESKTOP_ENVS="deepin"       
    DESKTOP_XINIT="startdde"     
    pacman -Syu --noconfirm --needed $Deepin_pkg                  
    CommonPrograms_Install                
    Desktop_Manager               
    sed -i 's/greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/'  /etc/lightdm/lightdm.conf
    Ct_log "function desktop_environment_deepin"
}
function desktop_environment_xfce4(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1;
    DESKTOP_ENVS=""          
    DESKTOP_XINIT="startxfce4"    
    pacman -Syu --noconfirm --needed $Xfce4_pkg
    CommonPrograms_Install                 
    Desktop_Manager                
    Ct_log "function desktop_environment_xfce4"
}
function desktop_environment_i3wm(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1; 
    DESKTOP_ENVS="i3wm"      
    DESKTOP_XINIT="i3"        
    pacman -Syu --noconfirm --needed "$i3wm_pkg"
    sed -i 's/i3-sensible-terminal/--no-startup-id termite/g' /home/"${CheckingUsers}"/.config/i3/config  # 更改终端
    CommonPrograms_Install             
    Desktop_Manager            
    Ct_log "function desktop_environment_i3wm"  
} 
function desktop_environment_i3gaps(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1; 
    DESKTOP_ENVS="i3gaps"      
    DESKTOP_XINIT="i3"        
    pacman -Syu --noconfirm --needed $i3gaps_pkg
    sed -i 's/i3-sensible-terminal/--no-startup-id termite/g' /home/"${CheckingUsers}"/.config/i3/config  # 更改终端
    CommonPrograms_Install             
    Desktop_Manager            
    Ct_log "function desktop_environment_i3gaps" 
}
function desktop_environment_lxde(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}"
    sleep 1; 
    DESKTOP_ENVS=""          
    DESKTOP_XINIT="startlxde"     
    pacman -Syu --noconfirm --needed $lxde_pkg
    CommonPrograms_Install                 
    Desktop_Manager         
    Ct_log "function desktop_environment_lxde" 
}
function desktop_environment_cinnamon(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}" 
    sleep 1; 
    DESKTOP_ENVS="cinnamon"      
    DESKTOP_XINIT="cinnamon-session"
    pacman -Syu --noconfirm --needed $Cinnamon_pkg
    CommonPrograms_Install                 
    Desktop_Manager     
    Ct_log "function desktop_environment_cinnamon"     
}
function desktop_environment_mate(){
    echo -e "${PSG} ${g}Configuring desktop environment.${h}" 
    sleep 1; 
    DESKTOP_ENVS="mate"      
    DESKTOP_XINIT="mate"        
    pacman -Syu --noconfirm --needed $mate_pkg
    CommonPrograms_Install                 
    Desktop_Manager         
    Ct_log "function desktop_environment_mate"  
}
# 安装桌面
function Install_Desktop_Env(){
    input_Desktop_env
    Output=$(echo -e "${PSG} ${y} Please select desktop${h} ${JHB}")
    DESKTOP_ID="0"   # 初始化变量
    read -p "${Output}"  DESKTOP_ID
    case ${DESKTOP_ID} in
        1)
            desktop_environment_plasma       
        ;;
        2)
            desktop_environment_gnome
        ;;
        3)
            desktop_environment_deepin
        ;;
        4)
            desktop_environment_xfce4
        ;;
        5)
            desktop_environment_i3wm
        ;;
        6)
            desktop_environment_i3gaps 
        ;;
        7)
            desktop_environment_lxde
        ;;
        8)
            desktop_environment_cinnamon
        ;;
        9)
            desktop_environment_mate
        ;;
        *)
            echo -e "${PSR} ${r} Selection error.${h}"    
            Process_Management stop "$0"
        esac
    Ct_log "function Install_Desktop_Env" 
}
function Configure_Xinitrc(){
    sed -i 's/\(twm &\)/ /' /etc/X11/xinit/xinitrc
    sed -i 's/\(xclock -geometry 50x50-1+1 &\)/ /' /etc/X11/xinit/xinitrc
    sed -i 's/\(xterm -geometry 80x50+494+51 &\)/ /' /etc/X11/xinit/xinitrc
    sed -i 's/\(xterm -geometry 80x20+494-0 &\)/ /' /etc/X11/xinit/xinitrc
    sed -i 's/\(exec xterm -geometry 80x66+0+0 -name login\)/ /' /etc/X11/xinit/xinitrc
}
# I/O驱动安装
function Install_Io_Driver(){
    #安装声音软件包
    echo -e "${PSG} ${g}Installing Audio driver.${h}"  
    pacman -Syu --noconfirm --needed $AudioDriver_Pkg
    systemctl enable alsa-state.service
    echo "load-module module-bluetooth-policy" >> /etc/pulse/system.pa
    echo "load-module module-bluetooth-discover" >> /etc/pulse/system.pa
    #触摸板驱动
    echo -e "${PSG} ${g}Installing input driver.${h}"  
    pacman -Syu --noconfirm --needed $inputDriver_Pkg
    # 蓝牙驱动
    echo -e "${PSG} ${g}Installing Bluetooth driver.${h}"  
    pacman -Syu --noconfirm --needed $BluetoothDriver_Pkg
    Ct_log "function Install_Io_Driver"
}
# CPU GPU驱动安装
function Install_Processor_Driver(){
    echo -e "\n$PSG ${g}Install the cpu ucode and driver.$h"
    if [[ "$CPU_Vendor" = 'intel' ]]; then
        pacman -Syu --noconfirm --needed $Intel_Pkg
        Ct_log "pacman -Syu --noconfirm --needed ${Intel_Pkg}"  
    elif [[ "$CPU_Vendor" = 'amd' ]]; then
        pacman -Syu --noconfirm --needed $Amd_Pkg
        Ct_log "pacman -Syu --noconfirm --needed ${Amd_Pkg}"
    else
        Output=$(echo -e "${PSG} ${y}Please select: Intel[1] AMD[2].${h} ${JHB}")
        read -p "${Output}"  DRIVER_GPU_ID
        case $DRIVER_GPU_ID in
            1)
                pacman -Syu --noconfirm --needed $Intel_Pkg
                Ct_log "pacman -Syu --noconfirm --needed ${Intel_Pkg}"
            ;;
            2)
                pacman -Syu --noconfirm --needed $Amd_Pkg
                Ct_log "pacman -Syu --noconfirm --needed ${Amd_Pkg}"
            ;;
        esac
    fi
    lspci -k | grep -A 2 -E "(VGA|3D)"  
    Output=$(echo -e "\n${PSG} ${y}Whether to install the Nvidia driver? [y/N]:${h} ${JHB}") 
    read -p "${Output}"  DRIVER_NVIDIA_ID
    case $DRIVER_NVIDIA_ID in
        [Yy]*)
            pacman -Syu --noconfirm --needed $Nvidia_A_Pkg
            yay -Sy --needed $Nvidia_B_Pkg
            systemctl enable optimus-manager.service 
            rm -f /etc/X11/xorg.conf 2&>/dev/null
            rm -f /etc/X11/xorg.conf.d/90-mhwd.conf 2&>/dev/null
            if [ -e "/usr/bin/gdm" ] ; then  # gdm管理器
                pacman -Syu --noconfirm --needed gdm-prime
                sed -i 's/#.*WaylandEnable=false/WaylandEnable=false/'  /etc/gdm/custom.conf
            elif [ -e "/usr/bin/sddm" ] ; then
                sed -i 's/DisplayCommand/# DisplayCommand/' /etc/sddm.conf
                sed -i 's/DisplayStopCommand/# DisplayStopCommand/' /etc/sddm.conf
            fi
        ;;
        [Nn]* )
            bash "$0"
        ;;
        * )
        Process_Management stop "$0"
        ;;
        esac   
    Ct_log "function Install_Processor_Driver"
}
# 安装Grub 配置
function Configure_Grub(){
    echo -e "${wg}Installing grub tools.${h}"  #安装grub工具   UEFI与Boot传统模式判断方式：ls /sys/firmware/efi/efivars  
    if ls /sys/firmware/efi/efivars &>/dev/null ; then    # 判断文件是否存在，存在为真，执行EFI，否则执行 Boot
        #-------------------------------------------------------------------------------#   
        echo -e "\n${PSG} ${w}Your startup mode has been detected as ${g}UEFI${h}.\n"  
        pacman -Syu --noconfirm --needed $Uefi_grub_Pkg
        grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archlinux --recheck   # 安装Grub引导
        Ct_log "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archlinux --recheck"
        grub-mkconfig -o /boot/grub/grub.cfg        # 生成配置文件
        echo;
        if efibootmgr | grep "Archlinux" &>/dev/null ; then      #检验 并提示用户
            echo -e "${g} Grub installed successfully -=> [Archlinux] ${h}"  
            echo -e "${g}     $(efibootmgr | grep "Archlinux")  ${h}\n"  
            Write_log_info "Grub installed successfully -=> [Archlinux]"
            Write_log_info "$(efibootmgr | grep "Archlinux")"
        else
            echo -e "${r} Grub installed failed ${h}"        # 如果安装失败，提示用户，并列出引导列表
            echo -e "${g}     $(efibootmgr)  ${h}\n"
        fi
    else   #-------------------------------------------------------------------------------#
        echo -e "\n${PSG} ${w}Your startup mode has been detected as ${g}Boot Legacy${h}.\n"  
        pacman -Syu --noconfirm --needed $Bios_grub_Pkg
        Disk_Boot=$(Query_List _Templist_ Bios_partition) 
        grub-install --target=i386-pc --recheck "${Disk_Boot}"    # 安装Grub引导
        Ct_log "grub-install --target=i386-pc --recheck ${Disk_Boot}"
        grub-mkconfig -o /boot/grub/grub.cfg            # 生成配置文件
        echo;
        if echo $? &>/dev/null ; then      #检验 并提示用户
                echo -e "${g} Grub installed successfully -=> [Archlinux] ${h}\n"  
        else
                echo -e "${r} Grub installed failed ${h}\n"        # 如果安装失败，提示用户，并列出引导列表
        fi
    fi
    Ct_log "function Configure_Grub"
}
# 配置本地化 时区 主机名 语音等
function Configure_System(){
    echo -e "${PSG} ${w}Configure enable Network.${h}"    
    systemctl enable NetworkManager          #配置网络 加入开机启动 NetworkManager
    #---------------------------------------------------------------------------#
    # 基础配置  时区 主机名 本地化 语言 安装语言包
    #-----------------------------
    echo -e "${PSG} ${w}Time zone changed to 'Shanghai'. ${h}"  
    ln -sf /usr/share/zoneinfo"$Area" /etc/localtime && hwclock --systohc # 将时区更改为"上海" / 生成 /etc/adjtime
    echo -e "${PSG} ${w}Set the hostname 'ArchLinux'. ${h}"
    echo "Archlinux" > /etc/hostname        # 设置主机名
    # 本地化设置 "英文"
    echo -e "${PSG} ${w}Localization language settings. ${h}"
    sed -i 's/#.*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && Ct_log "Write 'en_US.UTF-8 UTF-8' To /etc/locale.gen."  
    echo -e "${PSG} ${w}Write 'en_US.UTF-8 UTF-8' To /etc/locale.gen. ${h}"  
    # 本地化设置 "中文"
    sed -i 's/#.*zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && Ct_log "Write 'zh_CN.UTF-8 UTF-8' To /etc/locale.gen."    
    echo -e "${PSG} ${w}Write 'zh_CN.UTF-8 UTF-8' To /etc/locale.gen. ${h}" 
    locale-gen        # 生成 locale
    echo -e "${PSG} ${w}Configure local language defaults 'en_US.UTF-8'. ${h}"  
    echo "LANG=en_US.UTF-8" > /etc/locale.conf       # 系统语言 "英文" 默认为英文   
    Ct_log "function Configure_System"
}
# 安装virtualbox-guest-utils / open-vm-tools并配置
function install_virtualization_service(){
    if [[ "$Virtualization" = "vmware" ]]; then
        pacman -Syu --noconfirm --needed open-vm-tools gtkmm3 gtkmm gtk2 xf86-video-vmware xf86-input-vmmouse
        systemctl enable vmtoolsd.service
        systemctl enable vmware-vmblock-fuse.service
        systemctl start vmtoolsd.service
        systemctl start vmware-vmblock-fuse.service
    else
        pacman -Syu --noconfirm --needed virtualbox-guest-utils
        # pacman -Syu --noconfirm --needed "virtualbox-guest-utils virtualbox-guest-dkms"
        systemctl enable vboxservice.service
        systemctl start vboxservice.service
    fi 
    Ct_log "function install_virtualization_service"
}
# Nvidia显卡管理器 将PKGBUILD中的github替换了，会快一点【现在该函数未被引用】
function Nvidia_optimus-manager(){
    if [ ! -d ./Pkg/optimus-manager ]; then
        mkdir -p ./Pkg/optimus-manager
        if [ ! -e ./Pkg/optimus-manager/PKGBUILD ]; then
            echo -e "${PSG} ${w}Download ${y}optimus-manager ${w}PKGBUILD.${h}"
            curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/Pkg/optimus-manager/PKGBUILD > ./Pkg/optimus-manager/PKGBUILD
        fi
    fi
    if [ ! -d ./Pkg/optimus-manager-qt ]; then
        mkdir -p ./Pkg/optimus-manager-qt
        if [ ! -e ./Pkg/optimus-manager-qt/PKGBUILD ]; then
            echo -e "${PSG} ${w}Download ${y}optimus-manager-qt ${w}PKGBUILD.${h}"
            curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/Pkg/optimus-manager-qt/PKGBUILD > ./Pkg/optimus-manager-qt/PKGBUILD
        fi
    fi
    Ct_log "function Nvidia_optimus-manager"
}
# 脚本运行中，临时的命令输出 脚本测试时使用 进入脚本后输入“s”或“shell”
Shell_Exec(){
    input_Shell=$(echo -e "${PSY} ${y}Please enter a command or exit():${h} ${JHY}")
        read -p "${input_Shell}" input_Command

        if [ "$input_Command" = "exit()" ]; then
            bash "$0"
        else
            Exec_Command=$(${input_Command} 2>/dev/null || echo -e "$PSR ${r}auin: command not found: ${y}${input_Command} ${h}") 
            echo "$Exec_Command"
            bash "$0" -shell
        fi
    Ct_log "Shell_Exec"
}
function Archiso_Version_check(){
    Pattern=$(Query_List _Templist_ Pattern) 
    if [ "$Pattern" = "Chroot-OFF" ]; then
        if [ -e /run/archiso/bootmnt/loader/entries/archiso-x86_64-linux.conf ]; then
            Archiso_Version=$(grep "archisolabel=" < /run/archiso/bootmnt/loader/entries/archiso-x86_64-linux.conf | grep -v grep | awk '{print $3}' | cut -d"_" -f2)
            Archiso_Time=$((($(date +%s ) - $(date +%s -d "${Archiso_Version}01"))/86400))
            sed -i "12c Archiso_Version_check=no" "$Configure_tmp_list" 
            if [[ "$Archiso_Time" -ge 31 ]]; then
                echo -e "Please update as soon as possible Archiso !"
                sed -i "12c Archiso_Version_check=yes" "$Configure_tmp_list" 
            elif [[ "$Archiso_Time" -ge 61 ]]; then
                echo -e "You haven't updated in more than 30 days Archiso !"
                sed -i "12c Archiso_Version_check=yes" "$Configure_tmp_list" 
            elif [[ "$Archiso_Time" -ge 91 ]]; then
                echo -e "You haven't updated in more than 60 days Archiso !\n"
                read -p "Whether to start the script [Y]: " Version_check
                case $Version_check in
                    [Yy]*)
                        sleep 2;
                    ;;
                    *)
                        Process_Management stop "$0"
                    ;;
                esac
                sed -i "12c Archiso_Version_check=no" "$Configure_tmp_list" 
            elif [[ "$Archiso_Time" -ge 121 ]]; then
                echo -e "You haven't updated in more than 90 days Archiso !"
                Process_Management stop "$0"
                sed -i "12c Archiso_Version_check=no" "$Configure_tmp_list" 
            fi 
        fi
        Ct_log "function Archiso_Version_check"
    fi
}
#  用来日志记录的函数
Command=${0}
function Write_log_info(){
    DATE_N=$(date "+%Y-%m-%d %H:%M:%S")
    USER_N=$(whoami)
    echo "${DATE_N} ${USER_N} execute $Command [INFO] $*" >> "${Install_Log}" #执行成功日志打印路径
}
function Write_log_error(){
    DATE_N=$(date "+%Y-%m-%d %H:%M:%S")
    USER_N=$(whoami)
    echo -e "\033[41;37m ${DATE_N} ${USER_N} execute $Command [ERROR] $Command \033[0m"  >> "${Install_Log}" #执行失败日志打印路径
}
function Ct_log(){
if [  $? -eq 0  ]; then
    Write_log_info "$* sucessed."
    #echo -e "\033[32m $@ sucessed. \033[0m"
else
    Write_log_error "$* failed."
    #echo -e "\033[41;37m $@ failed. \033[0m"
    exit 1
fi
}
trap 'Ct_log "DO NOT SEND CTRL + C WHEN EXECUTE SCRIPT !!!! "'  2
# 命令 
# Ct_log “命令”
# 退出脚本
function Process_Management(){
    PM_Enter_1=${1}
    PM_Enter_2=${2}
    case ${PM_Enter_1} in
        start)
            bash "${Module}/Process_manage.sh" start "${PM_Enter_2}"
        ;;
        restart)
            bash "${Module}/Process_manage.sh" restart "${PM_Enter_2}"
        ;;
        stop)
            bash "${Module}/Process_manage.sh" stop "${PM_Enter_2}"
            echo -e "\n\n${wg}---------Script Exit---------${h}"  
            Ct_log "Script Exit"
        ;;
    esac
    Ct_log "function Process_Management => ${PM_Enter_1} ${PM_Enter_2}"
}

#===========从这里开始跑===========#
Init_Global_Variable
facts # Script self-test
System_Config_Global_Variable
Color_Global_Variable
Auin_Options "${1}"
Info_Ethernet
Update_Module

echo " " >> ${Install_Log}
date -d "2 second" +"%Y-%m-%d %H:%M:%S" &>> "${Install_Log}"
echo "Arch_install Script started" >> ${Install_Log}

ECHOA=$(echo -e "${w}          _             _       _     _                    ${h}") 
ECHOB=$(echo -e "${g}         / \   _ __ ___| |__   | |   (_)_ __  _   ___  __   ${h}")
ECHOC=$(echo -e "${b}        / _ \ | '__/ __| '_ \  | |   | | '_ \| | | \ \/ /  ${h}")
ECHOD=$(echo -e "${y}       / ___ \| | | (__| | | | | |___| | | | | |_| |>  <   ${h}")
ECHOE=$(echo -e "${r}      /_/   \_\_|  \___|_| |_| |_____|_|_| |_|\__,_/_/\_\  ${h}")
echo -e "$ECHOA\n$ECHOB\n$ECHOC\n$ECHOD\n$ECHOE" | lolcat 2>/dev/null || echo -e "$ECHOA\n$ECHOB\n$ECHOC\n$ECHOD\n$ECHOE"
Tips1=$(echo -e "${b}||============================================================||${h}")
Tips2=$(echo -e "${b}|| Script Name:    ${Version}.                                  ${h}") 
Tips3=$(echo -e "${g}|| Pattern:        ${ChrootPattern}                             ${h}")
Tips4=$(echo -e "${g}|| Ethernet:       ${Ethernet_ip:-No_network..} - [${Ethernet_Name:- }]                ${h}")
Tips5=$(echo -e "${g}|| WIFI:           ${Wifi_ip:-No_network.} - [${Wifi_Name:-No}]                     ${h}")
Tips6=$(echo -e "${g}|| SSH:            ssh $USER@${Ethernet_ip:-IP_Addess.}         ${h}")
Tips7=$(echo -e "${g}|| SSH:            ssh $USER@${Wifi_ip:-IP_Addess.}             ${h}")
Tips0=$(echo -e "${g}||============================================================||${h}")
echo -e "$Tips1\n$Tips2\n$Tips3\n$Tips4\n$Tips5\n$Tips6\n$Tips7\n$Tips0" | lolcat 2>/dev/null || echo -e "$Tips1\n$Tips2\n$Tips3\n$Tips4\n$Tips5\n$Tips6\n$Tips7\n$Tips0"
echo -e "\n${PSB} ${g}Configure Mirrorlist   [1]${h}"
echo -e "${PSB} ${g}Configure Network      [2]${h}"
echo -e "${PSG} ${g}Configure SSH          [3]${h}"
echo -e "${PSY} ${g}Install System         [4]${h}"
echo -e "${PSG} ${g}Exit Script            [Q]${h}"
READS_A=$(echo -e "\n${PSG} ${y} Please enter[1,2,3..] Exit[Q]${h} ${JHB}")
read -p "${READS_A}" principal_variable 
if [[ ${principal_variable} = 1 ]]; then
    bash "${Module}/mirrorlist.sh"
fi
if [[ ${principal_variable} = 2 ]]; then
    echo -e "\n$w:: Checking the currently available network."  
    sleep 2
    echo -e "$w:: Ethernet: ${r}${Ethernet_Name}${h}"
    echo -e "$w:: Wifi:   ${r}${Wifi_Name}${h}"
    READS_B=$(echo -e "${PSG} ${y}Query Network: Ethernet[1] Wifi[2] Exit[3]? ${h}${JHB}")
    read -p "${READS_B}" wlink 
        case $wlink in
            1) 
                Configure_Ethernet      
            ;;
            2) 
                Configure_wifi
            ;;
            3) 
                bash "${0}"
            ;;
        esac
fi
if [[ ${principal_variable} = 3 ]]; then
    Open_SSH;
fi
if [[ ${principal_variable} = 4 ]]; then
    input_System_Module
    Output=$(echo -e "${PSG} ${y} Please enter[1,2,21..] Exit[Q] ${h}${JHB}")
    read -p "${Output}" Tasks
    case ${Tasks} in
    0) # chroot 进入新系统
        Auin_chroot; 
    ;;
    1) #磁盘分区
        clear;partition # 选择磁盘 #parted /dev/sdb mklabel gpt   转换格式 GPT
        clear;partition_root      #root [/]
        partition_booting   #EFI / boot
        partition_swap      #swap file 虚拟文件(类似与win里的虚拟文件) 对于swap分区我更推荐这个，后期灵活更变
        sleep 1
        echo -e "${wg} ::==>> Partition complete. ${h}" 
        bash "${0}" 
    ;;
    2) # 安装及配置系统文件
        Install_Archlinux
        sleep 1
        echo;
        echo -e "${wg}#======================================================#${h}"
        echo -e "${wg}#::  System components installation completed.         #${h}"            
        echo -e "${wg}#::  Entering chroot mode.                             #${h}"
        echo -e "${wg}#::  Execute in 3 seconds.                             #${h}"
        echo -e "${wg}#::  Later operations are oriented to the new system.  #${h}"
        echo -e "${wg}#======================================================#${h}"
        sleep 3
        echo    # Chroot到新系统中完成基础配置，第一步配置
        cp -rf /etc/pacman.conf /mnt/etc/pacman.conf 
        cp -rf /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
        Auin_chroot;
    ;;
    21) # Installation Drive. 驱动, 配置驱动
        Driver_Package_Variable
        Install_Io_Driver
        Install_Processor_Driver
    ;;
    22) # Installation Desktop. 桌面环境
        ConfigurePassworld    # 引用函数：设置密码
        # 开始安装桌面环境
        #-----------------------------
        Desktop_Package_Variable
        Install_Desktop_Env
        #-------------------------------------------------------------------------------#     
        install_desktop_output=$(echo -e "${PSG} ${y}Whether to install Common Drivers? [y/N]:${h} ${JHB}")
        read -p "${install_desktop_output}" CommonDrive
        echo;
        case ${CommonDrive} in
        [Yy]*)
            Driver_Package_Variable
            Install_Io_Driver
        ;;
        [Nn]* )
        Process_Management stop "$0"
        ;;
        esac
    ;;
    23) # 进入系统后的配置
        Boot_Package_Variable
        Desktop_Package_Variable
        echo;Configure_Grub
        Configure_System
        #---------------------------------------------------------------------------#
        Install_Font        # 安装字体
        ConfigurePassworld    # 引用函数：设置密码
        echo -e "${ws}#======================================================#${h}" #本区块退出后的提示
        echo -e "${ws}#::                 Exit in 5/s                        #${h}" 
        echo -e "${ws}#::  When finished, restart the computer.              #${h}"
        echo -e "${ws}#::  If there is a problem during the installation     #${h}"
        echo -e "${ws}#::  please contact me. QQ:2763833502                  #${h}"
        echo -e "${ws}#======================================================#${h}"
        sleep 3
    ;;
    24) # Installation VM. open-vm-tools
        echo;install_virtualization_service
        sleep 3 
        bash "$0"
    ;;
    [Ss]* )
        Shell_Exec
    ;;
    [Qq]*)
        bash "$0"
;;
    esac
fi
case ${principal_variable} in
    [Qq]*)
        Process_Management stop "$0"
;;
    [Ss]* )
        Shell_Exec
    ;;
esac
