# arch_install
ArchLinux script Installer (安装脚本)

![Image text](https://raw.githubusercontent.com/BaSierL/arch_install/master/screenshot1.png)


# Auangz安装Arch Linux + Desktop 攻略

## 验证启动模式
```
  ls /sys/firmware/efi/efivars
```

## 检查网络
```
  ip link     #查看网卡设备
  ip link set [网卡] up   #开启网卡设备
  systemctl start dhcpcd      #开启DHCP服务
  wifi-menu    #连接wifi
```

## 配置 Mirrort
```
  vim /etc/pacman.d/mirrort
## China      # 中科大
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
## China      # 网易云
Server = https://mirrors.163.com/archlinux/$repo/os/$arch
## China      # 清华
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

### 磁盘分区

**分区命令**
```
  cfdisk /dev/sd[a-z][0-9] 
```
**格式化命令**
```
  mkfs.vfat  /dev/sd[a-z][0-9]    # efi/esp  fat32  
  mkfs.ext4 /dev/sd[a-z][0-9]
  mkswap /dev/sd[a-z][0-9]
  
```

## 验证启动模式
```
  ls /sys/firmware/efi/efivars
```

## 验证启动模式
```
  ls /sys/firmware/efi/efivars
```
