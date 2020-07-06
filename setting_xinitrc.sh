#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Arch Linux 安装脚本 
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git

sed -i 's/\(twm &\)/ /' /etc/X11/xinit/xinitrc
sed -i 's/\(xclock -geometry 50x50-1+1 &\)/ /' /etc/X11/xinit/xinitrc
sed -i 's/\(xterm -geometry 80x50+494+51 &\)/ /' /etc/X11/xinit/xinitrc
sed -i 's/\(xterm -geometry 80x20+494-0 &\)/ /' /etc/X11/xinit/xinitrc
sed -i 's/\(exec xterm -geometry 80x66+0+0 -name login\)/ /' /etc/X11/xinit/xinitrc