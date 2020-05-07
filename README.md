# Arch 安装脚本<a href='https://gitee.com/auroot/Arch_install/stargazers'><img src='https://gitee.com/auroot/Arch_install/badge/star.svg?theme=dark' alt='star'></img></a>
#### Script说明书 `注意大写的"A"`
#### [**点这里 GitHub 仓库地址**](https://github.com/BaSierL/Arch_install)
![输入图片说明](https://images.gitee.com/uploads/images/2020/0312/101913_b0e6e9cf_5700645.jpeg "1 (2).jpg")

## [点这里 安装图文教程](https://blog.csdn.net/weixin_42871436/article/details/105126833)


使用`curl` 下载`Arch_install.sh` 其他脚本我会内置到主体Script中，可以大大缩短你的安装时间：
```Shell
curl -fsSL http://wz4.in/10VQP > Arch_install.sh  #缩短后地地址
```
```Shell
curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/Arch_install.sh > Arch_install.sh
```
Arch Image中没有加入Git命令，所以如果你想克隆仓库，只能自行装```sudo pacman -S git```
```Shell
git clone https://gitee.com/auroot/Arch_install.git
```
**切换至Script目录中**
```Shell
chmod +x Arch_install.sh
bash Arch_install.sh
```
**联系**
```
QQ: 2763833502
```
## 脚本介绍
- 从无到有的一个过程：
- 许多重要提示，以及错误提示，熟悉脚本后10分钟内即可安装完毕，小白最好慢慢来，看清楚每个输入提示！
- 首页可看当前是否处于 Chroot 模式 开[ON]/关[OFF]
- Script启动主页显示IP地址(Wifi/有线)，提示：连接SSH服务命令
- 一键配置 SSH服务 镜像源;
- 网络配置：Wifi、有线;
- 可 ```UEFI```与```Boot Legacy```模式，“自动判断”;
- 自动配置 I/O，音频，蓝牙；
- 可选安装 Intel、AMD、Nvidia，安装完成自动配置；
- 桌面：Plasma(Min)、Gnome、Deepin、Xfce、i3wm、lxde、Cinnamon；
- 可选显示管理器：sddm、gdm、lightdm、lxdm；或默认(default)，可任意搭配,搭配时可以去网上搜一下,找最适合的搭配方案；
- 加固判断两次root和普通密码是否输入正确，以防输入错误，导致无法进入系统;
- 自检验最新Arch_install.sh,并提示更新;
- 脚本日志 保存日志地址:/tmp/Arch_install.log


![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/143132_e370a19e_5700645.jpeg)


![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/143312_60a8d9f5_5700645.png)


![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/143359_7279cc6a_5700645.png)


错误回馈码（exit）：
```
    exit 20    # 分区时输入错误
    exit 21    # 格式化Root分区时 输入错误 
    exit 22    # 格式化EFI分区时 输入错误 
    exit 23    # 格式化Swap File 时 输入错误 
```
