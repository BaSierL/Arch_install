#/bin/bash
# Author: Auroot/BaSierl
# QQ : 2763833502
# URL Blog  : www.auroot.cn 
# URL GitHub: https://github.com/BaSierL/arch_install.git
# URL Gitee : https://gitee.com/auroot/arch_install.git
#set -x
Wifi_Info="${2}/WifiInfo"
Wifi_Ssid="${2}/WifiSSID"
pacman -U ${1}/*
# 清除缓存  
rm -rf ${Wifi_Info}
rm -rf ${Wifi_Ssid}
# 检查 NetworkManager 是否已开启
ls /etc/systemd/system/multi-user.target.wants/NetworkManager.service > /dev/null 
if [[ $? != 0 ]]; then
    systemctl start NetworkManager.service 
fi 
# 检查 wpa_supplicant 是否已开启
ls /etc/systemd/system/multi-user.target.wants/wpa_supplicant.service > /dev/null
if [[ $? != 0 ]]; then
    systemctl start wpa_supplicant.service
fi

nmcli dev wifi list > ${Wifi_Info}
# 显示Wifi列表 Print wifi list 
cat ${Wifi_Info}
awk -F":" '{print $6}' < ${Wifi_Info}| awk -F" " '{print $2}' > ${Wifi_Ssid}
sed -i '/^$/d'  ${Wifi_Ssid} > /dev/null 
WifiListLine=$(wc -l < ${Wifi_Ssid})

Read_SSID=$(echo -e "You need to connect The first few WIFI.[1,2,3..]: ")
read -p "${Read_SSID}" UserNumber
if [[ ${UserNumber} -gt ${WifiListLine} ]]; then
    echo "Error: Enter Error No List ${UserNumber}."
    bash "$0";
    exit 1;
elif [[ ${UserNumber} -le ${WifiListLine} ]]; then
    for ((i=0; i<=${WifiListLine}; i++));
    do
        if [[ ${i} -eq ${UserNumber} ]]; then
            # Wifi序号
            WifiListNumber=${i}
            WifiSSID=$(sed -n "${WifiListNumber}"p < ${Wifi_Ssid})
            continue;
        fi
    done 
fi
echo " "
# 输入密码 Please Password
Read_Passwd=$(echo -e "Please enter your Wifi Password: ")
read -p "${Read_Passwd}" SSID_Passwd
# 连接Wifi connect Wifi
nmcli device wifi connect "${WifiSSID}" password "${SSID_Passwd}"
# 清除缓存
rm -rf ${Wifi_Info}
rm -rf ${Wifi_Ssid}






