#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Configure useradd
# URL Blog： https://basierl.github.io
# URL GitHub： https://github.com/BaSierL/arch_install.git
# URL Gitee ： https://gitee.com/auroot/arch_install.git
Temp_Data="${PWD}/Temp_Data"
null="/dev/null"
S_LINE(){
    sed -n -e '/# %wheel ALL=(ALL) NOPASSWD: ALL/=' /etc/sudoers
}
if [ ! -e "${Temp_Data}"/USERNAMES ]; then 
    UserName=$(whiptail --title "ArchLinux - UserName" --inputbox "Enter UserName:" 10 60  3>&1 1>&2 2>&3)  # 输入用户名 
    UserPassword=$(whiptail --title "ArchLinux - Password" --passwordbox "Enter User Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3) # 设置密码
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        useradd -m -g users -G wheel -s /bin/bash ${UserName}  # 新建用户
        echo ${UserName}:${UserPassword} | chpasswd &> /dev/null # 设置密码
        echo "${UserName}" > "${Temp_Data}"/UserName  # 备份
        #---------------------------------------------------------------------------#
        # 更改sudo 配置
        #-----------------------------
        if (whiptail --title "Configure Sudoers. Yes/No" --yesno "Auto Configure Sudoers." 10 60); then
            SUDOERS_LIST=$(S_LINE)
            chmod 770 /etc/sudoers  # 设置权限
            sed -i "${SUDOERS_LIST}i %wheel ALL=\(ALL\) NOPASSWD: ALL" /etc/sudoers
            chmod 440 /etc/sudoers  # 设置权限
            whiptail --title "Configure Sudoers." --msgbox "Configure Sudoers succeeded. [OK]" 10 60   # 设置sudo成功
        else
            whiptail --title "Configure Sudoers." --msgbox "Has been skipped. [X]" 10 60   # 跳过设置sudo
        fi
    fi
    RootPassword_A=$(whiptail --title "ArchLinux - Root Password" --passwordbox "Enter Root Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)  # 输入第一次root密码
    RootPassword_B=$(whiptail --title "ArchLinux - Root Password" --passwordbox "Again Enter Root Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)  # 输入第二次root密码
    exitstatus=$?
    if [ ${RootPassword_A} == ${RootPassword_B} ]; then
        echo root:${RootPassword_B} | chpasswd &> $null   # 输入两次正确，将在这里设置Root密码
        whiptail --title "Configure Root Password." --msgbox "Root Password setting complete. [OK]" 10 60   # 提示配置root密码成功
        echo "1" > "${Temp_Data}"/USERNAMES
    else    
        whiptail --title "Configure Root Password." --msgbox "Two passwords are inconsistent. [X]" 10 60    # 输入两次错误，返回信息
        exit 30;    # 输入两次错误，返回错误值
    fi
fi
