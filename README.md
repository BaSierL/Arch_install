# Arch 安装脚本
**对话框式安装脚本 [Archin分支] 暂时搁置！！！**
**请使用最新的archiso镜像或[2020.10.1 - 2020.12.1]**

使用`curl` 下载`auin.sh` 其他脚本我会内置到主体Script中，可以大大缩短你的安装时间：
更新速度：auroot.cn -> gitee -> github

```Shell
wget http://auroot.cn/auin
curl -fsSL http://auroot.cn/auin.sh > auin  # 稳定版 测试全通过！
chmod +x auin && bash auin
```
git
```Shell
curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/auin.sh > auin
chmod +x auin && bash auin
```

### 更新日志： [查看全部更新日志](https://gitee.com/auroot/Arch_install/blob/master/Update_Log.md)
#### Arch Linux System installation script V4.0.5 [测试镜像：2020.12.16]
已初步测试完成:
```
1. 解决无法创建用户的问题(感谢@HelloDream 提交issues);
2. 解决输入两次密码自动退出的问题；
3. 脚本选项输入“shell”或“s”进入临时终端，可输入常用命令(经测试：cd 无法跳转目录);
4. 新增脚本进程管理模块: “Module/Process_manage.sh”;
5. 去除模块: “Module/setting_xinitrc.sh” 整合至auin.sh;
6. 停用模块: “Wifi_Connect.sh”;
7. 优化部分语法;
```
**由于ArchLinux经常更新，安装方式也随之改变，导致脚本无法与之匹配，发生在某阶段出现错误，如果您发现问题，或以加以改进，可以创建Pull Request 提交脚本.**

### **联系**

```
ArchLinux群：204097403 @auroot
```

![输入图片说明](https://images.gitee.com/uploads/images/2020/1126/000802_cb4941f8_5700645.png "2020-11-25_23-58.png")

## 脚本介绍 [安装图文教程](https://blog.csdn.net/weixin_42871436/article/details/105126833)

- 从无到有的一个过程：
- 许多重要提示，以及错误提示，熟悉脚本后10分钟内即可安装完毕，小白最好慢慢来，看清楚每个输入提示！
- 选项的方式，完成单个任务的功能；

  - -m   配置源;
  - -w   配置wifi;
  - -s   配置并开启ssh服务;
  - -vm  安装并配置vm-tools;
  - -L   查看日志;
  - -h   帮助;
  - -v   版本;

- 首页可看当前是否处于 Chroot 模式 开[ON]/关[OFF]
- Script启动主页显示IP地址(Wifi/有线)，提示：连接SSH服务命令
- 一键配置 SSH服务 镜像源;
- 网络配置：Wifi(绕iwctl，使用NetworkManager连接wifi网络)、有线;
- 可 ```UEFI```与```Boot Legacy```模式，“自动判断”;
- 自动配置 I/O，音频，蓝牙；
- 可选安装 Intel、AMD、Nvidia，安装完成自动配置；
- 桌面：Plasma(Min)、Gnome、Deepin、Xfce、mate、lxde、Cinnamon、i3wm、i3gaps；
- 可选显示管理器：sddm、gdm、lightdm、lxdm；或默认(default)，可任意搭配,搭配时可以去网上搜一下,找最适合的搭配方案；
- 加固判断两次root和普通密码是否输入正确，以防输入错误，导致无法进入系统;
- 脚本日志 保存日志地址: ```Temp_Data/Arch_install.log```；
- auin.sh -vm 可根据硬件信息，安装与之对应的虚拟化工具包 [virtualbox/vmware];

![Script_Home](https://images.gitee.com/uploads/images/2020/1211/130919_b5e0120e_5700645.jpeg "script_home.jpg")

![选项功能](https://images.gitee.com/uploads/images/2020/1126/001843_1b29a1bf_5700645.png "2020-11-26_00-18.png")

![桌面环境选择](https://images.gitee.com/uploads/images/2020/1126/000925_1b198084_5700645.png "d.png")

![用户设置](https://images.gitee.com/uploads/images/2020/1126/000943_b4e3c687_5700645.png "u.png")

![日志](https://images.gitee.com/uploads/images/2020/1126/000953_f01ce7fe_5700645.png "l.png")
