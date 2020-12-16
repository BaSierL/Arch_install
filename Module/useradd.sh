#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Configure useradd -> auin V4.0.5
# URL Blog  : www.auroot.cn 
# URL GitHub: https://github.com/BaSierL/arch_install.git
# URL Gitee : https://gitee.com/auroot/arch_install.git
function S_LINE(){
    sed -n -e '/# %wheel ALL=(ALL) NOPASSWD: ALL/=' /etc/sudoers
}
Query_List(){
    Temp_list=$(cat $Configure_tmp_list)
    for i in ${Temp_list[*]}; do
        if [[ "$i" =~ ${1} ]]; then
            echo "$i" | cut -d"=" -f2
        fi 
    done
}
function Useradd_Config(){
PASSWORD_TYPED="false"
    while [ "$PASSWORD_TYPED" != "true" ]; do
        UserPassword=$(whiptail --title "ArchLinux - Password" --passwordbox "Enter User Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3) # 设置密码
        UserPassword_retype=$(whiptail --title "ArchLinux - Password" --passwordbox "Enter User Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3) # 设置密码
        if [ "$UserPassword" == "$UserPassword_retype" ]; then
            useradd -m -g users -G wheel -s /bin/bash ${UserName}  # 新建用户
            echo ${UserName}:${UserPassword} | chpasswd &> /dev/null # 设置密码
            sed -i "9c Users=${UserName}" $Configure_tmp_list 
            sed -i "10c Password=${UserPassword}" $Configure_tmp_list 
            whiptail --title "Configure User Password." --msgbox "The ${UserName} password configuration is complete. [OK]" 10 60   # 提示配置root密码成功
            PASSWORD_TYPED="true"
        else
            whiptail --title "Configure User Password." --msgbox "${UserName} password don't match. Please, type again. [X]" 10 60    # 输入两次错误，返回信息
        fi
    done
}
function Root_password_Config(){
    ROOT_PASSWORD_TYPED="false"
    while [ "$ROOT_PASSWORD_TYPED" != "true" ]; do
        RootPassword=$(whiptail --title "ArchLinux - Root Password" --passwordbox "Enter Root Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)  # 输入第一次root密码
        RootPassword_retype=$(whiptail --title "ArchLinux - Root Password" --passwordbox "Again Enter Root Password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)  # 输入第二次root密码
        if [ "$RootPassword" == "$RootPassword_retype" ]; then
            echo root:${RootPassword_retype} | chpasswd &> /dev/null   # 输入两次正确，将在这里设置Root密码
            whiptail --title "Configure Root Password." --msgbox "Root Password setting complete. [OK]" 10 60   # 提示配置root密码成功
            sed -i "11c Root_Password=${RootPassword_retype}" $Configure_tmp_list 
            ROOT_PASSWORD_TYPED="true"
        else
            whiptail --title "Configure Root Password." --msgbox "Root password don't match. Please, type again. [X]" 10 60    # 输入两次错误，返回信息
        fi
    done
}
function Sudo_Config(){
    if (whiptail --title "Configure Sudoers. Yes/No" --yesno "Auto Configure Sudoers." 10 60); then
        SUDOERS_LIST=$(S_LINE)
        chmod 770 /etc/sudoers  # 设置权限
        sed -i "${SUDOERS_LIST}i %wheel ALL=\(ALL\) NOPASSWD: ALL" /etc/sudoers
        chmod 440 /etc/sudoers  # 设置权限
        whiptail --title "Configure Sudoers." --msgbox "Configure Sudoers succeeded. [Ok]" 10 60   # 设置sudo成功
    else
        whiptail --title "Configure Sudoers." --msgbox "Has been skipped. [X]" 10 60   # 跳过设置sudo
    fi
}
function Variable(){
    Temp_Data="${1}" # 日志目录 Log Directory
    # Module="${1}"
# Configure_file="${Module}/install.conf"
    Configure_tmp_list="${Temp_Data}/auin.list"
# 该死的颜色
    y='\033[1;33m'  #---黄
    g='\033[1;32m'  #---绿
    h='\033[0m'
    PSY=$(echo -e "${y} ::==>${h}") 
}
Variable "${1}"
Root_Password=$(Query_List Root_Password)
UserName=$(Query_List Users) 
if [ "$Root_Password" = "" ]; then
    UserName=$(whiptail --title "ArchLinux - UserName" --inputbox "Enter UserName:" 10 60  3>&1 1>&2 2>&3)  # 输入用户名
    Useradd_Config
    Sudo_Config
    Root_password_Config
else
    whiptail --title "ArchLinux - User settings." --msgbox "Users: ${UserName}, Setup has been completed. [Ok]" 10 60
    echo -e "${PSY} ${y}The User: ${g}${UserName} ${y}has been set. [Ok]${h}"
fi
