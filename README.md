
# Arch 安装脚本
#### Script说明书 `注意大写的"A"`
#### [**GitHub 仓库地址**](https://github.com/BaSierL/Arch_install)
![输入图片说明](https://images.gitee.com/uploads/images/2020/0312/101913_b0e6e9cf_5700645.jpeg)

**脚本主体：**`Arch_install.sh`  你需要给这个脚本执行[x]权限

**镜像源副：**`mirrorlist.sh`    主体自动给他执行[x]权限


使用`curl` 下载`Arch_install.sh` 其他脚本我会内置到主体Script中，可以大大缩短你的安装时间：
```Shell
curl -fsSL http://suo.im/60X41l > Arch_install.sh  #缩短后地地址，1年有效期 始：2020.3.12
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
错误回馈码（exit）：
