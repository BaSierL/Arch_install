#!/bin/bash
# Author: Auroot/BaSierl
# QQ： 2763833502
# Description： Process Management. -> auin V4.0.5
# URL Blog  : www.auroot.cn 
# URL GitHub: https://github.com/BaSierL/arch_install.git
# URL Gitee : https://gitee.com/auroot/arch_install.git
# set -x
function Kill_Process(){
    Restart_shell_file="${1}"
    Process_PID=$(/usr/bin/ps -ef | grep "${Restart_shell_file}" | grep -v grep | awk '{print $2}')
    for Kill_Process_PID in ${Process_PID[*]}; do
    kill "$Kill_Process_PID"
    done
}
function Stript_Process_Management(){
    Exec_status="${1}"   # 启动 重启 停止
    Process_Path="${2}"  # 脚本 或者 进程
    case ${Exec_status} in
    start)
        bash "${Process_Path}"
        echo -e "\033[1;33m${Process_Path}\033[1;32m has been Start.\033[0m"
    ;;
    restart)
        Kill_Process "${Process_Path}"
        bash "${Process_Path}"
        echo -e "\033[1;33m${Process_Path}\033[1;32m has been Start.\033[0m"
    ;;
    stop)
        Kill_Process "${Process_Path}"
        echo -e "\033[1;33m${Process_Path}\033[1;32m has been Stopped.\033[0m"
    ;;
    *)
        exit 1;
    ;;
    esac    
}
# 
clear;
Stript_Process_Management "${1}" "${2}" # 1.状态 2.可执行文件
