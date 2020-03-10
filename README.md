## ArchLinux script Installer (脚本视图)
![脚本截图信息](https://gitee.com/auroot/arch_wiki/raw/master/Img/archlinux/img1.png?raw=true)
-------------------------------------------------------------------------------------------------
# Arch Linux + Desktop 攻略

## **免指令脚本**
[Bilibili - 详细视频讲解](https://www.bilibili.com/video/av88989589)
```shell
wget archfi.sf.net/archfi    # 获取archfi​
chmod +x archfi              # 增加脚本的可执行权限​
./archfi                     # 运行脚本​
```


## **安装步骤：**
[ArchLinux_Wiki - 安装教程](https://wiki.archlinux.org/index.php/Installation_guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

### 一、验证启动模式
```shell
[auroot@Archlinux ~]# ls /sys/firmware/efi/efivars
```

### 二、检查网络
[ArchLinux_Wiki - Network](https://wiki.archlinux.org/index.php/Network_configuration_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
``` Shell
ip link                     #查看网卡设备
ip link set [网卡] up       #开启网卡设备
systemctl start dhcpcd      #开启DHCP服务
wifi-menu                   #连接wifi
```

### 三、配置 Mirrort
``` shell
** 阿里云源
sed -i "6i Server = http://mirrors.aliyun.com/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist
** 网易云163 **
sed -i "6i Server = https://mirrors.163.com/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist
** 清华大学
sed -i "6i Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

更新一下
sudo pacman -Sy
```

### 四、磁盘分区
**分区命令**
[ArchLinux_Wiki - fdisk(分区工具)](https://wiki.archlinux.org/index.php/Fdisk_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```shell
cfdisk /dev/sda  # 指定磁盘
```
**格式化命令**
[ArchLinux_Wiki - File systems](https://wiki.archlinux.org/index.php/File_systems_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```shell
mkfs.vfat  /dev/sda[0-9]   # efi/esp  fat32  # 指定分区
mkfs.ext4 /dev/sda[0-9]    # ext4     # 指定分区
mkfs.ext3 /dev/sda[0-9]    # ext3     # 指定分区
mkswap /dev/sda[0-9]       # swap     # 指定分区
  
```

### 五、挂载分区
```shell
swapon /dev/sd[a-z][0-9]         # 挂着swap 卸载:swapoff
mount /dev/sd[a-z][0-9] /mnt     # 挂着根目录
mkdir -p /mnt/boot/EFI           # 创建efi引导目录
mount /dev/sda1 /mnt/boot/EFI    # 挂着efi分区
```

### 六、安装系统
```shell
pacstrap /mnt base base-devel linux linux-firmware ntfs-3g networkmanager os-prober net-tools
```
```shell
genfstab -U /mnt >> /mnt/etc/fstab     # 创建fstab分区表，记得检查
arch-chroot /mnt /bin/bash             # chroot 进入创建好的系统
```

### 七、配置系统
**设置时区**
```shell
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime     # 上海

hwclock --systohc       #运行 hwclock 以生成 /etc/adjtime
```

**本地化**
```shell
sed  -i "24i en_US.UTF-8 UTF-8" /etc/locale.gen
sed  -i "24i zh_CN.UTF-8 UTF-8" /etc/locale.gen

locale-gen             # 生成 locale
```

**系统语言**
```shell
echo "LANG=en_US.UTF-8" > /etc/locale.conf       # 英文
echo "LANG=zh_CN.UTF-8" > /etc/locale.conf       # 中文
```
**字体**
```shell
sudo pacman -S wqy-microhei wqy-zenhei ttf-dejavu
```

**主机名**
```shell
echo "Archlinux" > /etc/hostname  #主机名
passwd                 #给root设置密码
mkinitcpio -p linux    
```
**创建用户**
```shell
useradd -m -g users -G wheel -s /bin/bash 用户名

passwd 用户名           #给用户设置密码
```
需要开启的服务:
```
systemctl enable NetworkManager    #网络服务,不开没网
systemctl start NetworkManager

systemctl enable sshd.service      #SSH远程服务,随意
systemctl start sshd.service
```

**配置GRUB**
[ArchLinux_Wiki - GRUB](https://wiki.archlinux.org/index.php/GRUB_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

执行passwd 给root设置一个密码。
安装grub工具，到这一步，一定要看清楚。
```shell
pacman -S vim grub efibootmgr
# 最后
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archlinux
grub-mkconfig -o /boot/grub/grub.cfg
```

### 弄完重启
```shell
exit
swapoff /dev/sd[a-z][0-9]      #卸载swap
umount -R /mnt && reboot now   #卸载 根分区、efi分区
```

-------------------------------------------------------------------------------
## 安装驱动
**intel 显示驱动**
[ArchLinux_Wiki - Intel显卡](https://wiki.archlinux.org/index.php/Intel_graphics_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```shell
pacman -S xf86-video-intel mesa-libgl libva-intel-driver libvdpau-va-gl
```
**触摸板驱动**
```shell
sudo pacman -S xf86-input-libinput xf86-input-synaptics 
```
**蓝牙**
[ArchLinux_Wiki - 蓝牙](https://wiki.archlinux.org/index.php/Bluetooth_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
```shell
sudo pacman -S bluez bluez-utils blueman  bluedevil

sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
```
**音频**
```shell
sudo pacman -S pulseaudio-bluetooth alsa-utils
sudo vim /etc/pulse/system.pa

load-module module-bluetooth-policy
load-module module-bluetooth-discover
```
- 所有Video 驱动:
```
xf86-video-amdgpu                   
xf86-video-ati                      
xf86-video-dummy                    
xf86-video-fbdev                    
xf86-video-intel                    
xf86-video-nouveau                  
xf86-video-openchrome               
xf86-video-sisusb                   
xf86-video-vesa                     
xf86-video-vmware                   
xf86-video-voodoo                   
xf86-video-qxl
```

**安装I\O驱动**

```shell
sudo pacman -S xf86-input-keyboard xf86-input-mouse xf86-input-synaptics
```
- 其他I\O驱动
```
xf86-input-elographics                     
xf86-input-evdev                           
xf86-input-libinput                        
xf86-input-synaptics    
xf86-input-vmmouse      (VMWare)           
xf86-input-void                            
xf86-input-wacom                           
```

#### **打印机驱动**

[ArchLinux_Wiki - CUPS](https://wiki.archlinux.org/index.php/CUPS_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

CUPS 是苹果公司为Mac OS® X 和其他类 UNIX® 的操作系统开发的基于标准的、开源的打印系统.
首先要安装这5个包```sudo pacman -S cups ghostscript gsfonts gutenprint cups-usblp```
- ```samba```        如果系统用的 Samba 使用网络打印机，或者要作为打印服务器向其它windows客户端提供服务，你还需要安装
- ```cups```         就是传说中的CUPS软件```
- ```ghostscript```  Postscript语言的解释器```
- ```gsfonts```      Ghostscript标准Type1字体```
- ```hpoj```         HP Officejet, 你应该再安装这个包```

### **手机文件系统支持**
```
sudo pacman -S mtpaint mtpfs libmtp 
Gnome ： gvfs-mtp 
Kde ：kio-extras
```

-------------------------------------------------------------------------------
## **Nvidia 显示驱动**
- [Optimus-switch - 解决方案](https://github.com/dglt1)

- [Optimus-manager-qt - 解决方案(自用推荐)](https://github.com/Shatur95/optimus-manager-qt)

- 可能需要开启AUR源 
- 可能需要开启软件源 [multilib]
```
sudo rm -f /etc/X11/xorg.conf
sudo rm -f /etc/X11/xorg.conf.d/90-mhwd.conf
sudo systemctl disable bumblebeed.service   #如果正在使用bumblebee,请禁用守护进程

# gdm管理器
yaourt -S gdm-prime         
sudo vim /etc/gdm/custom.conf
    #WaylandEnable=false        前面的#去掉 Gnomoe的显示管理器就是gdm(Gnome xorg模式)

# sddm管理器
sudo vim /etc/sddm.conf     
    DisplayCommand              #找到这行，注释#
    DisplayStopCommand          #找到这行，注释#

#安装NVidia及主程序
sudo pacman -S nvidia nvidia-utils opencl-nvidia lib32-nvidia-utils lib32-opencl-nvidia mesa lib32-mesa-libgl xf86-video-intel
sudo pacman -S optimus-manager optimus-manager-qt   #安装optimus-manager

sudo systemctl enable optimus-manager.service       #开启进程 
```
----------------------------------------------------------------------------------------------

**查看n卡的BusID**
```
$ lspci | egrep 'VGA|3D'
出现如下格式：
----------------------------------------------------------------------
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 630 (Desktop)
01:00.0 VGA compatible controller: NVIDIA Corporation GP107M [GeForce GTX 1050 Ti Mobile] (rev a1)
————————————————
```
**解决画面撕裂问题**
```
[auroot@Arch ~]# vim /etc/mkinitcpio.conf
----------------------------------------------------------------------
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
----------------------------------------------------------------------

[auroot@Arch ~]# vim /etc/default/grub                                              # 此处必须是grub引导，其他引导自行百度
----------------------------------------------------------------------
GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1"               #此处加nvidia-drm.modeset=1参数
----------------------------------------------------------------------

[auroot@Arch ~]# grub-mkconfig -o /boot/grub/grub.cfg                           
```
**nvidia升级时自动更新initramfs**
```
[auroot@Arch ~]# sudo mkdir /etc/pacman.d/hooks
[auroot@Arch ~]# sudo vim /etc/pacman.d/hooks/nvidia.hook
-----------------------------------------------------------------
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update Nvidia module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
```

**安装测试软件  在图形界面下**
```
[auroot@Arch ~]# sudo pacman -S virtualgl
[auroot@Arch ~]# optirun glxspheres64

#查看NVIDIA显卡是否已经启动
[auroot@Arch ~]# nvidia-smi
```
## **以下可不用加入配置**
**SDDM**
```
[auroot@Arch ~]# vim /usr/share/sddm/scripts/Xsetup
----------------------------------------------------------------------
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
```

**GDM**
```
创建两个桌面文件
[auroot@Arch ~]# sudo mkdir /usr/share/gdm/greeter/autostart/optimus.desktop
[auroot@Arch ~]# sudo mkdir /etc/xdg/autostart/optimus.desktop
----------------------------------------------------------------------
[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer
```

**修改配置文件**
```
[auroot@Arch ~]# vim /etc/X11/xorg.conf
----------------------------------------------------------------------
Section "Module"                                                      
    load "modesetting"
EndSection

Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "1:0:0"                                            #此处填刚刚查询到的BusID
    Option         "AllowEmptyInitialConfiguration"
EndSection
```



-------------------------------------------------------------------------------
# Deepin 桌面安装
![Image text](https://images.gitee.com/uploads/images/2020/0216/212915_593e4787_5700645.jpeg)

#### **安装桌面**

[ArchLinux_Wiki - DEEPIN](https://wiki.archlinux.org/index.php/Deepin_Desktop_Environment_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```
sudo pacman -S xorg xorg-server xorg-xinit mesa deepin deepin-extra lightdm

vim /etc/lightdm/lightdm.conf

  greeter-session=example-gtk-gnome       # 用VIM 找到这个
  
  greeter-session=lightdm-deepin-greeter  # 替换为这个

sudo systemctl enable lightdm             # 加入开机自启

vim /etc/X11/xinit/xinitrc  # 配置这个文件

  exec startdde     # 添加这个
  
cp /etc/X11/xinit/xinitrc /home/用户名/.xinitrc

systemctl start lightdm     # 开启桌面 
```
-------------------------------------------------------------------------------
# Kde 桌面
![Image KDE_Desktop](https://images.gitee.com/uploads/images/2020/0302/152309_29015fac_5700645.jpeg "kde.jpg")

### **安装桌面**

[ArchLinux_Wiki - KDE](https://wiki.archlinux.org/index.php/KDE_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

```
sudo pacman -S sddm sddm-kcm plasma xorg xorg-server xorg-xinit mesa     # 安装软件包 

sudo pacman -S plasma-desktop plasma-meta   # 完整桌面，软件自己安装
sudo pacman -S kde-applications-meta        # 全部加游戏，什么都有，臃肿
sudo systemctl enable sddm          # 加入开机自启 
    echo "exec startkde" >> /etc/X11/xinit/xinitrc  
    cp /etc/X11/xinit/xinitrc $HOME/.xinitrc
```
```sudo pacman -S konsole               # KDE终端``` 

-------------------------------------------------------------------------------
# Gnome 桌面
![Image Gnome_Desktop](https://images.gitee.com/uploads/images/2020/0302/152750_9d75eb84_5700645.png "desktop_8t.png")

### **安装桌面**

[ArchLinux_Wiki - GNOME](https://wiki.archlinux.org/index.php/GNOME_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
```
gnome-extra 额外包，可不装。
sudo pacman -S xorg xorg-server xorg-xinit mesa gnome gdm
    sudo systemctl enable gdm 
    echo "exec gnome=session" >> /etc/X11/xinit/xinitrc
    cp /etc/X11/xinit/xinitrc $HOME/.xinitrc
```

进入登录界面后，设置为以 GNOME no Xorg模式登入（推荐）
```
美化地址：https://www.pling.com/s/Gnome
         https://www.opencode.net/explore/projects
安装插件需要的软件：
sudo pacman -S gnome-tweaks gnome-shell-extensions
```
**插件**
```
Arch Linux Updates Indicator    archlinux软件更新检测插件,需要配合pacman-contrib使用
Caffeine                        防止自动挂起
Clipboard Indicator             一个剪贴板
Coverflow Alt-Tab               更好的窗口切换
Dash to Dock                    把dash栏变为一个dock
Dynamic Top Bar                 顶栏透明化
Extension Update Notifier       gnome插件更新提示
GnomeStatsPro                   一个系统监视器
system-monitor                  又一个系统监视器
Night Light Slider              调节gnome夜间模式的亮度情况
OpenWeather                     天气插件
Proxy Switcher                  代理插件
Random Wallpaper                自动切换壁纸,
Simple net speed                网速监测
Sound Input & Output Device Chooser 声音设备选择
Status Area Horizontal Spacing  让顶栏更紧凑
Suspend Button                  添加一个休眠按钮
TopIcons Plus                   把托盘图标放到顶栏
Window Is Ready - Notification Remover      去除烦人的window is ready提醒
```
-------------------------------------------------------------------------------
## Aur源 \ Backarch源 

###### **[ArchLinux_Wiki - AUR安装](https://wiki.archlinux.org/index.php/AUR_helpers_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))**
###### **[AUR工具 - yay](https://github.com/Jguer/yay)**
###### **[科学上网 - electron-ssr](https://gitee.com/auroot/arch_wiki/releases/electron-ssr)**
- ###  中科大
```
echo '' >> /etc/pacman.conf
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'SigLevel = Optional TrustedOnly' >> /etc/pacman.conf
echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
```

- ###  清华
```
echo '' >> /etc/pacman.conf
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'SigLevel = Optional TrustedOnly' >> /etc/pacman.conf
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
```

- ### 163
```
echo '' >> /etc/pacman.conf
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'SigLevel = Optional TrustedOnly' >> /etc/pacman.conf
echo 'Server = http://mirrors.163.com/archlinux-cn/$arch' >> /etc/pacman.conf
```

### Blackarch

- ###  清华
```
echo '' >> /etc/pacman.conf
echo '[blackarch]' >> /etc/pacman.conf
echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/blackarch/$repo/os/$arch' >> /etc/pacman.conf
```

```
    sudo pacman -Syu yaourt yay
    sudo pacman -Syu archlinuxcn-keyring
```
-------------------------------------------------------------------------------

# 常用软件
```
pacman -S vim git wget zsh  dosfstools man-pages-zh_cn create_ap p7zip file-roller unrar neofetch openssh 

sudo pacman -S google-chrome        # 谷歌浏览器
sudo pacman -S firefox              # 火狐浏览器
sudo pacman -S bash-complete        # 增强自动补全功能
sudo pacman -S xpdf                 # 安装pdf阅读器
sudo pacman -Sy yaourt              # 另外一个包管理工具
sudo pacman -S cowsay               # 牛的二进制图形（/usr/share/cows）
sudo yaourt -S vundle-git           # 安装vim的插件管理器
sudo pacman -S deepin.com.qq.office	# TIM
sudo pacman -S deepin-movie         # 深度影院
sudo yaourt -S deepin-wechat        # 微信
sudo pacman -S netease-cloud-music  # 网易云音乐
sudo pacman -S iease-music          # 第三方网易云音乐
sudo pacman -S virtualbo            # virtualbox 虚拟机
sudo pacman -S vmware-workstation   # vmware 虚拟机
sudo pacman -S wps-office           # wps
sudo pacman -S remmina              # 好用远程工具

https://github.com/xtuJSer/CoCoMusic/releases   # QQ音乐  CoCoMusic

sudo mandb                          # 中文的man手册，更新关键词搜索需要的缓存
```
-------------------------------------------------------------------------------

**安装字体**
[ArchLinux_Wiki - 字体](https://wiki.archlinux.org/index.php/Fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- 全部安装：
```shell
sudo pacman -S --needed font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf \
ttf-bitstream-vera ttf-dejavu ttf-liberation xorg-fonts-type1 ttf-ms-fonts \
gnu-free-fonts noto-fonts ttf-bitstream-vera ttf-caladea ttf-carlito \
ttf-croscore ttf-dejavu ttf-hack ttf-junicode ttf-linux-libertine \
opendesktop-fonts ttf-anonymous-pro ttf-arphic-ukai ttf-arphic-uming \
ttf-baekmuk ttf-cascadia-code ttf-cormorant ttf-droid ttf-fantasque-sans-mono \
ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-font-awesome ttf-hanazono \
ttf-hannom ttf-ibm-plex ttf-inconsolata ttf-indic-otf ttf-ionicons \
ttf-jetbrains-mono ttf-joypixels ttf-khmer ttf-lato ttf-liberation \
ttf-linux-libertine-g ttf-nerd-fonts-symbols ttf-opensans ttf-proggy-clean \
ttf-roboto ttf-roboto-mono ttf-sazanami ttf-tibetan-machine ttf-ubuntu-font-family
```
-------------------------------------------------------------------------------
### **TIM - KDE**

**1、安装TIM**
```shell
sudo pacman -S deepin.com.qq.office 
```
**2、第二个包很重要**
```shell
sudo pacman -S gnome-settings-daemon
```
**3、打开TIM，自启gsd-xsettings （推荐），只对TIM有效。**
```shell
sudo vim /usr/share/applications/deepin.com.qq.office.desktop

注释： Exec=“/opt/deepinwine/apps/Deepin-TIM/run.sh” -u %u
加入：Exec=/usr/lib/gsd-xsettings || /opt/deepinwine/apps/Deepin-TIM/run.sh
```

-------------------------------------------------------------------------------

### **sogou输入法**

[ArchLinux_Wiki - Fcitx](https://wiki.archlinux.org/index.php/Fcitx_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

- 安装搜狗输入法及其依赖
```shell
[auroot@Arch ~]# sudo pacman -S yaourt
[auroot@Arch ~]# yaourt -S qtwebkit-bin
# 安装搜狗输入法及其依赖
[auroot@Arch ~]# sudo pacman -S fcitx fcitx-im fcitx-configtool fcitx-libpinyin kcm-fcitx fcitx-sogoupinyin
# 配置输入法的工具 -U参数是安装本地包.
[auroot@Arch ~]# wget https://arch-archive.tuna.tsinghua.edu.cn/2019/04-29/community/os/x86_64/fcitx-qt4-4.2.9.6-1-x86_64.pkg.tar.xz  
[auroot@Arch ~]# sudo pacman -U fcitx-qt4-4.2.9.6-1-x86_64.pkg.tar.xz 
```
- 配置环境 把下面的加入到`/.xporfile
```shell
[auroot@Arch ~]# sudo vim /etc/profile 
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export LC_CTYPE=zh_CN.UTF-8
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
fcitx -d -r --enable sogou-qimpanel
```
```shell
[auroot@Arch ~]# sudo vim /etc/environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

```
- 终端运行qtconfig-qt4找到interface选项,在下面的Defult Input Method改为fcitx然后保存退出 source /etc/profile 重启。

-------------------------------------------------------------------------------
## 隐藏grub引导菜单

如果使用了其他引导，可以隐藏linux的grub引导菜单，修改下面文件：
```
sudo vim /etc/default/grub
```
```
GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
GRUB_DISABLE_OS_PROBER=true
```
更新grub：
```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## rEFInd 引导双系统
如果你的电脑支持UEFI启动引导又嫌弃默认的启动界面丑，你可以使用rEFInd来管理你的启动项，推荐一个主题Minimal. 引导设置可参考rEFInd引导Win10+Ubuntu14双系统.
我的启动界面截图：
```
rEFInd：https://github.com/EvanPurkhiser/rEFInd-minimal
rEFInd引导Win10+Ubuntu：https://www.cnblogs.com/shishiteng/p/5760345.html
```
-------------------------------------------------------------------------------
## Fstab配置文件
```
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>

# /dev/sdb2
UUID=ID     /               ext4        rw,relatime     0   1

# /dev/sdb1
UUID=ID     /boot/efi       vfat         rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro   0   2

# /dev/sdb3
UUID=ID     none            swap        defaults        0   0

#/dev/nvme0n1p2  Windows file ntfs 
UUID=ID     /mnt/c          ntfs,ntfs-3g        defaults,auto,uid=1000,gid=985,umask=002,iocharset=utf8     0   0

#/dev/sda3  Win D file  ntfs  
UUID=ID     /mnt/d          ntfs,ntfs-3g        defaults,auto,uid=1000,gid=985,umask=002,iocharset=utf8     0   0
```

### VirtualBox
- VirtualBox 拓展
```
sudo pacman -S virtualbox-guest-utils  (For Virtualbox)
```

-------------------------------------------------------------------------------
# 待续....
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
