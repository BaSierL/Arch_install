# Arch 安装脚本

### 之前发布更新的脚本未经测试就上传了，非常抱歉 给大家带来了不便。
### 使用此脚本是请使用master分支的，最新且测试通过~
#### 建议不要用我的脚本安装驱动，推荐自行安装，上面有Intel Amd NVIDIA I/O等驱动，驱动这块很少更新，如果需要可以留言，需求大，我就看看有没有需要更新的，应该是没什么问题，不管是什么驱动，就算上游更新勤，配置也不会有大更变。 

#### Script说明书 `注意大写的"A"`

#### [**点这里 GitHub 仓库地址**](https://github.com/BaSierL/Arch_install)

![输入图片说明](https://images.gitee.com/uploads/images/2020/1126/000802_cb4941f8_5700645.png "2020-11-25_23-58.png")

## [点这里 安装图文教程](https://blog.csdn.net/weixin_42871436/article/details/105126833)

- **由于ArchLinux经常更新，安装方式也随之改变，导致脚本无法与之匹配，发生在某阶段出现错误.**
- **如果您发现问题，或以加以改进，可以创建Pull Request 提交脚本.**

### **新版对话框式安装脚本正在编写，可进入Archin分支查看，加入请加作者！！！**


使用`curl` 下载`auin.sh` 其他脚本我会内置到主体Script中，可以大大缩短你的安装时间：

```Shell
wget http://auroot.cn/auin.sh 

curl -fsSL http://auroot.cn/auin.sh > auin.sh #缩短后地地址
```

```Shell
curl -fsSL https://gitee.com/auroot/Arch_install/raw/master/auin.sh > auin.sh
```

Arch Image中没有加入Git命令，所以如果你想克隆仓库，只能自行装```sudo pacman -S git```

```Shell
git clone https://gitee.com/auroot/Arch_install.git
```

**切换至Script目录中**

```Shell
chmod +x auin.sh
bash auin.sh
```

**联系**

```
QQ/微信: 2763833502
```

## 脚本介绍

- 从无到有的一个过程：
- 许多重要提示，以及错误提示，熟悉脚本后10分钟内即可安装完毕，小白最好慢慢来，看清楚每个输入提示！
- 首页可看当前是否处于 Chroot 模式 开[ON]/关[OFF]
- Script启动主页显示IP地址(Wifi/有线)，提示：连接SSH服务命令
- 一键配置 SSH服务 镜像源;
- 网络配置：Wifi(绕iwctl，使用NetworkManager连接wifi网络)、有线;
- 可 ```UEFI```与```Boot Legacy```模式，“自动判断”;
- 自动配置 I/O，音频，蓝牙；
- 可选安装 Intel、AMD、Nvidia，安装完成自动配置；
- 桌面：Plasma(Min)、Gnome、Deepin、Xfce、i3wm、lxde、Cinnamon；
- 可选显示管理器：sddm、gdm、lightdm、lxdm；或默认(default)，可任意搭配,搭配时可以去网上搜一下,找最适合的搭配方案；
- 加固判断两次root和普通密码是否输入正确，以防输入错误，导致无法进入系统;
- 更新说明 新增与改进：
  1. 脚本日志 保存日志地址: ```Temp_Data/Arch_install.log```；
  2. 重新设计了大部分代码（如有bug可加我qq或者Issues，提醒我哟！）
  3. 易携带选项的方式，完成单个任务的功能；
     - -m   配置源
     - -w   配置wifi
     - -s    配置并开启ssh服务
     - -L    查看日志
     - -h    帮助
     - -v    版本
 4. 解决了Nvme固态硬盘无法匹配的问题；

![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/143132_e370a19e_5700645.jpeg)

![选项功能](https://images.gitee.com/uploads/images/2020/1126/001843_1b29a1bf_5700645.png "2020-11-26_00-18.png")

![桌面环境选择](https://images.gitee.com/uploads/images/2020/1126/000925_1b198084_5700645.png "d.png")

![用户设置](https://images.gitee.com/uploads/images/2020/1126/000943_b4e3c687_5700645.png "u.png")

![日志](https://images.gitee.com/uploads/images/2020/1126/000953_f01ce7fe_5700645.png "l.png")

错误回馈码（exit）：

```
    exit 20    # 分区时输入错误
    exit 21    # 格式化Root分区时 输入错误 
    exit 22    # 格式化EFI分区时 输入错误 
    exit 23    # 格式化Swap File 时 输入错误 
```
