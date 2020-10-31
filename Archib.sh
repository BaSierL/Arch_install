#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Arch Linux 安装脚本  V4.0
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git
# 脚本文件:/tmp/Arch_install_script.log
# Pacman安装日志: /tmp/install_programs.log
# Archin目录为临时数据,安装过程中需要用来读取

# 当前时间
Time_Up=$(date -d "2 second" +"%Y-%m-%d %H:%M:%S")

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
Programs=" "
Pacmans(){
    sudo pacman -Sy --needed --noconfirm ${Programs} | tee -a /tmp/install_Temp >> /tmp/install_programs.log  # --needed 如果程序已存在即不安装,--noconfirm 不进行交互,直接安装
    if [[ $? == 0 ]]; then
        echo -e "${PSG} ${g}The installation is complete. ${h}"
    else
        echo -e "${PSR} ${r} installation failed!!! ${h}"
    fi
}

# 记录脚本已启动
echo "Arch_install Script started || Arch_install 脚本已启动 \n\t\t${Time_Up}" >> /tmp/Arch_install_script.log 
# 应用函数  如果觉得每次打开脚本,速度很慢,可以注释下面一行!
Down_Update
# 检查当前目录有没有mirrorlist.sh文件，没有就导入
Down_Mirrorlist

null="/dev/null"

##======== 安装ArchLinux    选项4 ==========================================
# 函数：设置root密码 用户  判断/etc/passwd文件中最后一个用户是否大于等于1000的普通用户，如果没有请先创建用户
    ConfigurePassworld(){
        PasswdFile="/etc/passwd"
        if [ -e /Archin/UserName ]; then   #  设定一个文件匹配，这个文件在不在都无所谓
            for ((Number=1;Number<=50;Number++))  # 设置变量Number 等于1 ；小于等于50 ； Number 1+1直到50
            do
            Query=$(tail -n ${Number} ${PasswdFile} | head -n 1 | cut -d":" -f3)
                for Contrast in {1000..1100}
                do
                    if [[ $Query == $Contrast ]]; then
                        CheckingUsers=$(cat ${PasswdFile} | grep "$Query" | cut -d":" -f1)
                        CheckingID=$(cat ${PasswdFile} | grep "$Query" | cut -d":" -f3)
                    fi
                done 
            done
            echo "$CheckingUsers" > /Archin/UserName  
            CheckingUsers=$(cat /Archin/UserName)
            echo -e "${PSG} ${g}A normal user already exists, The UserName:${h} ${b}${CheckingUsers}${h} ${g}ID: ${b}${CheckingID}${h}." | tee -a /tmp/install_Temp && Write_Log
            sleep 2;
        else
            sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/useradd.sh)"
            CheckingUsers=$(cat /Archin/UserName)
            echo -e "${PSG} ${g}A normal user already exists, The UserName:${h} ${b}${CheckingUsers}${h}." | tee -a /tmp/install_Temp && Write_Log
            sleep 2;
        fi
    }


    InSystemFile(){
# list2========== 安装及配置系统文件 ==========222222222222222
    if [[ ${tasks} == 2 ]]; then
            echo -e "${wg}Update the system clock.${h}" | tee -a /tmp/install_Temp #更新系统时间
            timedatectl set-ntp true | tee -a /tmp/install_Temp 
            sleep 2
            echo;
            echo -e "${PSG} ${g}Install the base packages.${h}" | tee -a /tmp/install_Temp   #安装基本系统
            echo;
                pacstrap /mnt base base-devel linux | tee -a /tmp/install_Temp  # 第一部分
                pacstrap /mnt linux-firmware linux-headers ntfs-3g networkmanager net-tools dhcpcd vim | tee -a /tmp/install_Temp  # 第二部分 分开安装，避免可不必要的错误！
                Write_Log 
            echo;
	        sleep 2
            echo -e "${PSG}  ${g}Configure Fstab File.${h}" | tee -a /tmp/install_Temp  #配置Fstab文件
	        genfstab -U /mnt >> /mnt/etc/fstab | tee -a /tmp/install_Temp && Write_Log
            sleep 1
            echo;
            clear;
            echo;
            echo;
            echo -e "${wg}#======================================================#${h}"
            echo -e "${wg}#::  System components installation completed.         #${h}"            
            echo -e "${wg}#::  Entering chroot mode.                             #${h}"
            echo -e "${wg}#::  Execute in 3 seconds.                             #${h}"
            echo -e "${wg}#::  Later operations are oriented to the new system.  #${h}"
            echo -e "${wg}#======================================================#${h}"
            sleep 3
            echo    # Chroot到新系统中完成基础配置，第一步配置
            cp -rf /tmp/Arch_install_script.log /mnt/tmp/Arch_install_script.log
            cat /tmp/diskName_root > /mnt/diskName_root
            cp -rf /etc/pacman.conf /mnt/etc/pacman.conf 2&> ${null}
            cp -rf /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist 2&> ${null}

            cat $0 > /mnt/Arch_install.sh  && chmod +x /mnt/Arch_install.sh
            arch-chroot /mnt /bin/bash /Arch_install.sh 
            # cp -rf /etc/pacman.conf.bak /mnt/etc/pacman.conf 2&> ${null}
            # cp -rf /etc/pacman.d/mirrorlist.bak /mnt/etc/pacman.d/mirrorlist 2&> ${null}
    fi
    }
    InDrive(){
#==========  Installation Drive. 驱动  ===========3333333333333
    if [[ ${tasks} == 21 ]]; then
        #---------------------------------------------------------------------------#
        #  配置驱动
        #-------------------
        sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)" 
        #安装声音软件包
        echo -e "${PSG} ${g}Installing Audio driver.${h}" | tee -a /tmp/install_Temp
        Programs="alsa-utils pulseaudio pulseaudio-bluetooth pulseaudio-alsa"
        Pacmans;
        echo "load-module module-bluetooth-policy" >> /etc/pulse/system.pa
        echo "load-module module-bluetooth-discover" >> /etc/pulse/system.pa
        #触摸板驱动
        echo -e "${PSG} ${g}Installing input driver.${h}" | tee -a /tmp/install_Temp 
        Programs="xf86-input-synaptics xf86-input-libinput create_ap"
        Pacmans;
        # 蓝牙驱动
        echo -e "${PSG} ${g}Installing Bluetooth driver.${h}" | tee -a /tmp/install_Temp && Write_Log
        Programs="bluez bluez-utils blueman bluedevil"
        Pacmans;
        echo;
        READDRIVE_GPU=$(echo -e "${PSG} ${y}Please choose: Intel[1] AMD[2] Skip[3]${h} ${JHB}")
        read -p "${READDRIVE_GPU}"  DRIVER_GPU_ID
        case $DRIVER_GPU_ID in
            1)
                Programs="xf86-video-intel intel-ucode xf86-video-intel xf86-video-intel mesa-libgl libva-intel-driver libvdpau-va-gl"
                Pacmans;
            ;;
            2)
                Programs="xf86-video-ati amd-ucode"
                Pacmans;
            ;;
            3)
                echo;
            ;;
        esac
        lspci -k | grep -A 2 -E "(VGA|3D)" | tee -a /tmp/install_Temp && Write_Log
        echo;
        READDRIVE_NVIDIA=$(echo -e "${PSG} ${y}Please choose: Nvidia[1] Exit[2]${h} ${JHB}") 
        read -p "${READDRIVE_NVIDIA}"  DRIVER_NVIDIA_ID
            case $DRIVER_NVIDIA_ID in
                1)
                    Programs="nvidia nvidia-utils opencl-nvidia lib32-nvidia-utils lib32-opencl-nvidia mesa lib32-mesa-libgl optimus-manager optimus-manager-qt" 
                    Pacmans;
                    systemctl enable optimus-manager.service | tee -a /tmp/install_Temp 
                    rm -f /etc/X11/xorg.conf 2&> /tmp/install_Temp 
                    rm -f /etc/X11/xorg.conf.d/90-mhwd.conf 2&> /tmp/install_Temp && Write_Log

                    if [ -e "/usr/bin/gdm" ] ; then  # gdm管理器
                        Programs="gdm-prime"
                        Pacmans; 
                        sed -i 's/#.*WaylandEnable=false/WaylandEnable=false/'  /etc/gdm/custom.conf
                    elif [ -e "/usr/bin/sddm" ] ; then
                        sed -i 's/DisplayCommand/# DisplayCommand/' /etc/sddm.conf
                        sed -i 's/DisplayStopCommand/# DisplayStopCommand/' /etc/sddm.conf
                    fi
                ;;
                2)
                    bash $0
                ;;
            esac      
    fi
    }
    InDesktop(){
# list22==========  Installation Desktop. 桌面环境 ==========444444444444444444444444444
    if [[ ${tasks} == 22 ]]; then
        ConfigurePassworld    # 引用函数：设置密码
        sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)" 
        # 定义 桌面环境配置函数
        Desktop_Env_Config(){
            systemctl enable $(cat /Archin/Desktop_Manager) | tee -a /tmp/install_Temp 
            sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/setting_xinitrc.sh)"
            echo "exec ${DESKTOP_XINIT}" >> /etc/X11/xinit/xinitrc 
            CheckingUser=$(cat /Archin/UserName)
            cp -rf /etc/X11/xinit/xinitrc  /home/${CheckingUser}/.xinitrc 
            echo -e "${PSG} ${w}${DESKTOP_ENVS} ${g}Desktop environment configuration completed.${h}" | tee -a /tmp/install_Temp && Write_Log
            sleep 2;   # 以下是配置 ohmyzsh
            #sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/install_zsh.sh)"
        } 
    # 函数 桌面管理选择
    # 软件包列表 及 读取变量DESKTOP_MANAGER_NAME,安装桌面/显示管理器  
        Desktop_Manager(){
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
                    elif [[ $DESKTOP_ENVS == "lxde" ]] ; then
                        DESKTOP_MANAGER_NAME="lxdm"
                    elif [[ $DESKTOP_ENVS == "cinnamon" ]] ; then
                        DESKTOP_MANAGER_NAME="lightdm"
                    fi
                ;;
            esac
            echo ${DESKTOP_MANAGER_NAME} > /Archin/Desktop_Manager
                # IN_SDDM_PKG="sddm sddm-kcm"
                # IN_GDM_PKG="gdm"
                # IN_LIGHTDM_PKG="lightdm"
                # IN_LXDM_PKG="lxdm"
                Desktop_Manager_ID=$(cat /Archin/Desktop_Manager)
                if [[ ${Desktop_Manager_ID} == "sddm" ]] ; then
                    Programs="sddm sddm-kcm"  #--安装SDDM
                elif [[ ${Desktop_Manager_ID} == "gdm" ]] ; then
                    Programs="gdm"    #--安装GDM
                elif [[ ${Desktop_Manager_ID} == "lightdm" ]] ; then
                    Programs="lightdm"   #--安装lightdm
                elif [[ ${Desktop_Manager_ID} == "lxdm" ]] ; then
                    Programs="lxdm"  #--安装LXDM
                fi
        }

    # 定义 其他基本包函数
        Programs_Name(){
            sudo pacman -Sy --needed ttf-dejavu ttf-liberation thunar neofetch  unrar unzip p7zip \
                zsh vim git ttf-wps-fonts google-chrome mtpfs mtpaint libmtp kchmviewer file-roller flameshot | tee -a /tmp/install_Temp && Write_Log
        }
#-----------#---------------------------------------------------------------------------#
        # 开始安装桌面环境
        #-----------------------------
        echo
        echo -e "     ${w}***${h} ${b}Install Desktop${h} ${w}***${h}  " 
        echo "---------------------------------"
        echo -e "${PSB} ${g}   KDE plasma.     ${h}${w}[1]${h}  --sddm"
        echo -e "${PSB} ${g}   Gnome.          ${h}${w}[2]${h}  --gdm"
        echo -e "${PSB} ${g}   Deepin.         ${h}${w}[3]${h}  --lightdm"    
        echo -e "${PSB} ${g}   Xfce4.          ${h}${w}[4]${h}  --lightdm"  
        echo -e "${PSB} ${g}   i3wm.           ${h}${w}[5]${h}  --sddm"
        echo -e "${PSB} ${g}   lxde.           ${h}${w}[6]${h}  --lxdm"
        echo -e "${PSB} ${g}   Cinnamon.       ${h}${w}[7]${h}  --lightdm"
        echo "---------------------------------"                           
        echo;
            CHOICE_ITEM_DESKTOP=$(echo -e "${PSG} ${y} Please select desktop${h} ${JHB}")
            DESKTOP_ID="0"   # 初始化变量
            read -p "${CHOICE_ITEM_DESKTOP}"  DESKTOP_ID
            case ${DESKTOP_ID} in
                1)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1;
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa plasma plasma-desktop konsole dolphin kate plasma-pa kio-extras powerdevil kcm-fcitx | tee -a /tmp/install_Temp
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    Programs_Name;               # 安装其他基本包
                    DESKTOP_ENVS="plasma"       # 桌面名
                    DESKTOP_XINIT="startkde"    # 桌面环境启动 
                    Desktop_Env_Config;          #
                    
                    #-------------------------------------------------------------------------------# 
                ;;
                2)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1;
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa gnome gnome-extra gnome-tweaks gnome-shell \
                    gnome-shell-extensions gvfs-mtp gvfs gvfs-smb gnome-keyring
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    Programs_Name;                   # 安装其他基本包
                    DESKTOP_ENVS="gnome"            # 桌面名
                    DESKTOP_XINIT="gnome=session"   # 桌面环境启动
                    Desktop_Env_Config;              #
                    
                    #-------------------------------------------------------------------------------#
                ;;
                3)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1;
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa deepin deepin-extra lightdm-deepin-greeter | tee -a /tmp/install_Temp 
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    Programs_Name;              # 安装其他基本包
                    sed -i 's/greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/'  /etc/lightdm/lightdm.conf
                    DESKTOP_ENVS="deepin"      # 桌面名
                    DESKTOP_XINIT="startdde"   # 桌面环境启动
                    Desktop_Env_Config;         #
                    
                    #-------------------------------------------------------------------------------#
                ;;
                4)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1;
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa xfce4 xfce4-goodies light-locker xfce4-power-manager libcanberra | tee -a /tmp/install_Temp 
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    Programs_Name;               # 安装其他基本包
                    DESKTOP_ENVS="xfce"         # 桌面名
                    DESKTOP_XINIT="startxfce4"  # 桌面环境启动
                    Desktop_Env_Config;          #
                    
                    #-------------------------------------------------------------------------------#
                ;;
                5)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1; 
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa i3 i3-gaps i3lock i3status compton dmenu feh picom nautilus \
                    polybar gvfs-mtp xfce4-terminal termite | tee -a /tmp/install_Temp 
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    sed -i 's/i3-sensible-terminal/--no-startup-id termite/g' /home/${CheckingUser}/.config/i3/config  # 更改终端
                    Programs_Name;          # 安装其他基本包
                    DESKTOP_ENVS="i3wm"     # 桌面名
                    DESKTOP_XINIT="i3"      # 桌面环境启动
                    Desktop_Env_Config;     #
                    
                    #-------------------------------------------------------------------------------#  
                ;;
                6)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1; 
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa lxde | tee -a /tmp/install_Temp 
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    Programs_Name;              # 安装其他基本包
                    DESKTOP_ENVS="lxde"         # 桌面名
                    DESKTOP_XINIT="startlxde"   # 桌面环境启动
                    Desktop_Env_Config;          #
                    
                #-------------------------------------------------------------------------------#  
                ;;
                7)
                    echo -e "${PSG} ${g}Configuring desktop environment.${h}" | tee -a /tmp/install_Temp && sleep 1; 
                    sudo pacman -Sy --needed xorg xorg-server xorg-xinit mesa cinnamon blueberry gnome-screenshot gvfs \
                    gvfs-mtp gvfs-afc exfat-utils faenza-icon-theme accountsservice gnoem-terminal | tee -a /tmp/install_Temp 
                    Desktop_Manager && sudo pacman -Sy --needed ${Programs}  # 选择桌面管理器
                    Programs_Name;              # 安装其他基本包
                    DESKTOP_ENVS="cinnamon"     # 桌面名
                    DESKTOP_XINIT="cinnamon-session"  # 桌面环境启动
                    Desktop_Env_Config      #
                    
                #-------------------------------------------------------------------------------#  
                ;;
                *)
                    echo -e "${PSR} ${r} Selection error.${h}" | tee -a /tmp/install_Temp 
                    exit 26
                esac
            Write_Log; 
            #-------------------------------------------------------------------------------#     
            READDRIVE_CommonDrive=$(echo -e "${PSG} ${y}Whether to install Common Drivers: Install[y] No[*]${h} ${JHB}")
            read -p "${READDRIVE_CommonDrive}" CommonDrive
            echo;
            case ${CommonDrive} in
            y | Y | yes | YES)
                #安装声音软件包
                echo -e "${PSG} ${g}Installing Audio driver.${h}" | tee -a /tmp/install_Temp 
                Programs="alsa-utils pulseaudio pulseaudio-bluetooth pulseaudio-alsa"
                Pacmans;
                echo "load-module module-bluetooth-policy" >> /etc/pulse/system.pa
                echo "load-module module-bluetooth-discover" >> /etc/pulse/system.pa
                #触摸板驱动
                echo -e "${PSG} ${g}Installing input driver.${h}" | tee -a /tmp/install_Temp 
                Programs="xf86-input-synaptics xf86-input-libinput create_ap"
                Pacmans;
                # 蓝牙驱动
                echo -e "${PSG} ${g}Installing Bluetooth driver.${h}" | tee -a /tmp/install_Temp 
                Programs="bluez bluez-utils blueman bluedevil"
                Pacmans;
                Write_Log;
            ;;
            * )
                exit 0
            ;;
            esac
    fi
    }
    ConfSystem(){
# list5==========  进入系统后的配置 ===========55555555555555555555
    if [[ ${tasks} == 23 ]]; then
            sh -c "$(curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/mirrorlist.sh)"
            #安装grub工具   UEFI与Boot传统模式判断方式：ls /sys/firmware/efi/efivars  Boot引导判断磁盘地址：cat /mnt/diskName_root
            echo -e "${wg}Installing grub tools.${h}" | tee -a /tmp/install_Temp 
                if (ls /sys/firmware/efi/efivars &> /dev/null) ; then    # 判断文件是否存在，存在为真，执行EFI，否则执行 Boot
                    #-------------------------------------------------------------------------------#   
                    echo;
                    echo -e "${PSG} ${w}Your startup mode has been detected as ${g}UEFI${h}." | tee -a /tmp/install_Temp 
                    echo;  
                    Programs="grub efibootmgr os-prober"
                    Pacmans; 
                    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archlinux | tee -a /tmp/install_Temp # 安装Grub引导
                    grub-mkconfig -o /boot/grub/grub.cfg | tee -a /tmp/install_Temp      # 生成配置文件
                    echo;
                    if (efibootmgr | grep "Archlinux" &> ${null}) ; then      #检验 并提示用户
                        echo -e "${g} Grub installed successfully -=> [Archlinux] ${h}" | tee -a /tmp/install_Temp
                        echo -e "${g}     `efibootmgr | grep "Archlinux"`  ${h}" | tee -a /tmp/install_Temp 
                        echo;   
                    else
                        echo -e "${r} Grub installed failed ${h}" | tee -a /tmp/install_Temp      # 如果安装失败，提示用户，并列出引导列表
                        echo -e "${g}     `efibootmgr`  ${h}" | tee -a /tmp/install_Temp  
                        echo; 
                    fi
                    Write_Log;
                else   #-------------------------------------------------------------------------------#
                    echo;
                    echo -e "${PSG} ${w}Your startup mode has been detected as ${g}Boot Legacy${h}." | tee -a /tmp/install_Temp 
                    echo;
                    Programs="grub os-prober"
                    Pacmans;
                    Disk_Boot=$(cat /diskName_root)
                    grub-install --target=i386-pc ${Disk_Boot} | tee -a /tmp/install_Temp   # 安装Grub引导
                    grub-mkconfig -o /boot/grub/grub.cfg | tee -a /tmp/install_Temp                        # 生成配置文件
                    echo;
                    if (echo $? &> ${null}) ; then      #检验 并提示用户
                            echo -e "${g} Grub installed successfully -=> [Archlinux] ${h}" | tee -a /tmp/install_Temp 
                            echo;   
                    else
                            echo -e "${r} Grub installed failed ${h}" | tee -a /tmp/install_Temp    # 如果安装失败，提示用户，并列出引导列表
                            echo; 
                    fi
                    Write_Log;
                fi
                echo -e "${PSG} ${w}Configure enable Network.${h}" | tee -a /tmp/install_Temp 
                systemctl enable NetworkManager | tee -a /tmp/install_Temp         #配置网络 加入开机启动 NetworkManager
                systemctl enable dhcpcd | tee -a /tmp/install_Temp && Write_Log        # 加入开机启动 dhcpcd
                #---------------------------------------------------------------------------#
                # 基础配置  时区 主机名 本地化 语言 安装语言包
                #-----------------------------
                echo -e "${PSG} ${w}Time zone changed to 'Shanghai'. ${h}" | tee -a /tmp/install_Temp
                    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock --systohc # 将时区更改为"上海" / 生成 /etc/adjtime
                echo -e "${PSG} ${w}Localization language settings. ${h}" | tee -a /tmp/install_Temp
                echo "Archlinux" > /etc/hostname        # 设置主机名
                    sed -i 's/#.*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen      # 本地化设置 "英文"
                    sed -i 's/#.*zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen      # 本地化设置 "中文"
                    locale-gen | tee -a /tmp/install_Temp      # 生成 locale
                echo -e "${PSG} ${w}Configure local language defaults 'en_US.UTF-8'. ${h}" | tee -a /tmp/install_Temp
                echo "LANG=en_US.UTF-8" > /etc/locale.conf       # 系统语言 "英文" 默认为英文   
                # echo "LANG=zh_CN.UTF-8" > /etc/locale.conf     # 系统语言 "中文"
                echo -e "${PSG} ${w}Install Fonts. ${h}" | tee -a /tmp/install_Temp && Write_Log
                    Programs="wqy-microhei wqy-zenhei ttf-dejavu ttf-ubuntu-font-family noto-fonts" # 安装语言
                    Pacmans;
                #---------------------------------------------------------------------------#
                ConfigurePassworld;   # 引用函数：设置密码
        echo -e "${ws}#======================================================#${h}" #本区块退出后的提示
        echo -e "${ws}#::                 Exit in 5/s                        #${h}" 
        echo -e "${ws}#::  When finished, restart the computer.              #${h}"
        echo -e "${ws}#::  If there is a problem during the installation     #${h}"
        echo -e "${ws}#::  please contact me. QQ:2763833502                  #${h}"
        echo -e "${ws}#======================================================#${h}"
        sleep 3
    fi
fi
    }

# 显示当前磁盘信息
DiskInfo(){ #Show current disk information 
    lsblk | grep -E "sda|sdb|sdc|sdd|sdg|nvme"> /tmp/install_Temp && Write_Log 
    lsblk | grep -E "sda|sdb|sdc|sdd|sdg|  nvme"> DiskInfo 
    whiptail --title "Disk information" --textbox DiskInfo 25 80
}
# Chroot 新系统
    Chroot(){
        cat $0 > /mnt/Archib  && chmod +x /mnt/Archib
        arch-chroot /mnt /bin/bash /Archib
    }


OPTION=$(whiptail --title "Menu Home" --menu "Please select." 15 60 6 \
        "1" "Disk partition." \
        "2" "Install System Files." \
        "3" "Installation Drive." \
        "4" "Installation Desktop." \
        "5" "Configurt System." \
        "6" "arch-chroot /mnt." 3>&1 1>&2 2>&3)
case ${Root} in
    1)
        EditDisk;
    ;;
    2)
        InstallSystem;
    ;;
    3)
        InstallDrive;
    ;;
    4)
        InstallDesktop;
    ;;
    5)
        ConfigurtSystem;
    ;;
    6)
        Chroot;
    ;;
esac

#从文件中查看
whiptail --title "Message box title" --textbox /etc/fstab 25 80

# https://blog.csdn.net/rong_toa/article/details/86255761
# http://www.ttlsa.com/linux-command/linux-dialog-shell/
