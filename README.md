# arch_install
ArchLinux script Installer (安装脚本)
![Image text](https://github.com/BaSierL/arch_install/blob/master/screenshot1.png)


# Auangz安装Arch Linux + Desktop 攻略

### 验证启动模式
```
[auroot@Archlinux ~]# ls /sys/firmware/efi/efivars
```

### 检查网络
``` Shell
ip link          #查看网卡设备
ip link set [网卡] up        #开启网卡设备
systemctl start dhcpcd      #开启DHCP服务
wifi-menu        #连接wifi
```

### 配置 Mirrort
``` shell
vim /etc/pacman.d/mirrorlist
## China      # 中科大
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
## China      # 网易云
Server = https://mirrors.163.com/archlinux/$repo/os/$arch
## China      # 清华
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
更新一下
sudo pacman -Sy
```

### 磁盘分区

**分区命令**
```
[auroot@Arch ~]# cfdisk /dev/sd[a-z][0-9] 
```
**格式化命令**
```
[auroot@Arch ~]# mkfs.vfat  /dev/sd[a-z][0-9]    # efi/esp  fat32  
[auroot@Arch ~]# mkfs.ext4 /dev/sd[a-z][0-9]     # ext4 
[auroot@Arch ~]# mkfs.ext3 /dev/sd[a-z][0-9]     # ext3
[auroot@Arch ~]# mkswap /dev/sd[a-z][0-9]        # swap
  
```

### 挂载分区
```
[auroot@Arch ~]# swapon /dev/sd[a-z][0-9]         # 挂着swap
[auroot@Arch ~]# swapoff /dev/sd[a-z][0-9]        # 卸载swap  
[auroot@Arch ~]# mount /dev/sd[a-z][0-9] /mnt     # 挂着根目录
[auroot@Arch ~]# mkdir -p /mnt/boot/EFI           # 创建efi引导目录
[auroot@Arch ~]# mount /dev/sda1 /mnt/boot/EFI    # 挂着efi分区
```

### 安装系统
```
[auroot@Arch ~]# pacstrap -i /mnt base base-devel linux
```
```
[auroot@Arch ~]# genfstab -U /mnt >> /mnt/etc/fstab     # 创建fstab分区表，记得检查
[auroot@Arch ~]# arch-chroot /mnt /bin/bash             # chroot 进入创建好的系统
```

### 配置系统
**设置时区**
```
[auroot@Arch ~]# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime     # 上海

[auroot@Arch ~]# hwclock --systohc       #运行 hwclock 以生成 /etc/adjtime
```

**本地化**
```
[auroot@Arch ~]# vim /etc/locale.gen    # 把以下复制到这个文件
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8  

[auroot@Arch ~]# locale-gen             # 生成 locale
```

**系统语言**
```
[auroot@Arch ~]# echo "LANG=en_US.UTF-8" > /etc/locale.conf       # 英文
[auroot@Arch ~]# echo "LANG=zh_CN.UTF-8" > /etc/locale.conf       # 中文
```

**主机名**
```
[auroot@Arch ~]# echo "Archlinux" > /etc/hostname
```
**配置GRUB**

执行passwd 给root设置一个密码。
安装grub工具，到这一步，一定要看清楚。
```
[auroot@Arch ~]# pacman -S vim grub efibootmgr
# 最后
[auroot@Arch ~]# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Archlinux
[auroot@Arch ~]# grub-mkconfig -o /boot/grub/grub.cfg
```

### 弄完重启
```
[auroot@Arch ~]# exit
[auroot@Arch ~]# swapoff /dev/sd[a-z][0-9]      #卸载swap
[auroot@Arch ~]# umount -R /mnt && reboot now   #卸载 根分区、efi分区
```

## 能正常开机，就可以看以下部分

**没有网络? --> [可以往上翻](https://github.com/BaSierL/arch_install/blob/master/README.md#%E6%A3%80%E6%9F%A5%E7%BD%91%E7%BB%9C)** 

**安装软件**
```
# 以下常用软件
pacman -S vim git wget zsh ntfs-3g networkmanager dosfstools man-pages-zh_cn create_ap p7zip file-roller unrar neofetch openssh net-tools

# 以下配置
systemctl enable NetworkManager
systemctl start NetworkManager

systemctl enable sshd.service
systemctl start sshd.service

sudo mandb      # 中文的man手册，更新关键词搜索需要的缓存

# 以下识别Windows 引导
pacman -S os-prober
grub-mkconfig -o /boot/grub/grub.cfg
```

**创建用户**
```
useradd -m -g users -G wheel -s /bin/bash 用户名

passwd 用户名        #给用户设置密码
```

**安装字体**
```
sudo pacman -S wqy-microhei wqy-zenhei ttf-dejavu
```

## 安装驱动
**触摸板驱动**
```
sudo pacman -S xf86-input-libinput xf86-input-synaptics 

```

**intel 显示驱动**
```
sudo pacman -S xf86-video-intel mesa-libgl libva-intel-driver libvdpau-va-gl
```

**安装输入设备驱动**
```
pacman -S xf86-input-keyboard xf86-input-mouse
```

**Nvidia 显示驱动**
```
sudo pacman -S nvidia nvidia-settings  opencl-nvidia lib32-nvidia-utils lib32-opencl-nvidia mesa lib32-mesa-libgl xf86-video-nouveau bumblebee

systemctl enable bumblebee.service
sudo gpasswd -a 用户名 bumblebee
```
```
# 大黄蜂配置  不稳
sudo pacman -S bbswitch
#编辑
sudo vim /etc/bumblebee/bumblebee.conf
-----------------------
指定nvidia
Driver=nvidia
电源管理指定bbswitch
[driver-nvidia] 
PMMethod=bbswitch
-----------------------

sudo tee /proc/acpi/bbswitch <<< ON     #开启

sudo tee /proc/acpi/bbswitch <<< OFF    #关闭
```
安装测试软件  在图形界面下：
```
sudo pacman -S virtualgl
optirun glxspheres64

#查看NVIDIA显卡是否已经启动
nvidia-smi
```

## 手机文件系统支持
```
sudo pacman -S mtpaint mtpfs libmtp 
Gnome ： gvfs-mtp 
Kde ：kio-extras
```

## 图像界面依赖安装
```
sudo pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils mesa
```

# Deepin 桌面安装
![Image text](https://img.iplaysoft.com/wp-content/uploads/2016/deepin/deepin_linux.jpg)
```
sudo pacman -S deepin deepin-extra lightdm

vim /etc/lightdm/lightdm.conf

  greeter-session=example-gtk-gnome       # 用VIM 找到这个
  
  greeter-session=lightdm-deepin-greeter  # 替换为这个

sudo systemctl enable lightdm             # 加入开机自启

vim /etc/X11/xinit/xinitrc  # 配置这个文件

  exec startdde     # 添加这个
  
cp /etc/X11/xinit/xinitrc /home/用户名/.xinitrc

systemctl start lightdm     # 开启桌面 
```

# Kde5 桌面
![Image text](https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561834821555&di=add73721aa159756b3c83b164fc511a2&imgtype=0&src=http%3A%2F%2Fyesky2.img.xzstatic.com%2Fnews%2F201906%2F51007918ba389136331402170193b2e7.jpg)

**安装桌面**
```
sudo pacman -S sddm sddm-kcm plasma     # 安装软件包
sudo systemctl enable sddm          # 加入开机自启  

sudo pacman -S plasma-desktop plasma-meta   # 完整桌面，软件自己安装
sudo pacman -S kde-applications-meta        # 全部加游戏，什么都有，臃肿

vim /etc/X11/xinit/xinitrc  # 配置这个文件

   exec startkde     # 添加这个
  
cp /etc/X11/xinit/xinitrc /home/用户名/.xinitrc
```

# yaourt安装
### 编辑
sudo vim /etc/pacman.conf

### 添加   中科大
```
[archlinuxcn]
#The Chinese Arch Linux communities packages.
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```
### 添加   清华
```
[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
sudo pacman -Syu yaourt
```

# 常用软件
```
sudo pacman -S google-chrome        # 谷歌浏览器
sudo pacman -S firefox              # 火狐浏览器
sudo pacman -S bash-complete        # 增强自动补全功能
sudo pacman -S xpdf                 # 安装pdf阅读器
sudo pacman -Sy yaourt              # 另外一个包管理工具
sudo pacman -S lilyterm             # 安装台湾的这个终端（透明背景什么的）
sudo pacman -S fortune-mod          # 让vim更有意思的包（随机显示）（/usr/share/fortune/off）
sudo pacman -S cowsay               # 牛的二进制图形（/usr/share/cows）
sudo yaourt -S vundle-git           # 安装vim的插件管理器
sudo pacman -S deepin.com.qq.office	# TIM
sudo pacman -S netease-cloud-music  # 网易云音乐
sudo pacman -S deepin-movie         # 深度影院
sudo yaourt -S deepin-wechat        # 微信
sudo pacman -S netease-cloud-music  # 网易云音乐
sudo pacman -S iease-music          # 第三方网易云音乐
sudo pacman -S virtualbo            # virtualbox 虚拟机
sudo pacman -S vmware-workstation   # vmware 虚拟机
sudo pacman -S wps-office           # wps
https://github.com/xtuJSer/CoCoMusic/releases   # QQ音乐  CoCoMusic
```
# 待续....

