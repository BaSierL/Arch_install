#/bin/bash
#set -x
# 清除缓存
rm -rf /tmp/WifiInfo
rm -rf /tmp/WifiSSID
pacman -U ./Wifi_pkg/*
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

nmcli dev wifi list > /tmp/WifiInfo 
# 显示Wifi列表 Print wifi list 
cat /tmp/WifiInfo 
awk -F":" '{print $6}' < /tmp/WifiInfo | awk -F" " '{print $2}' > /tmp/WifiSSID
sed -i '/^$/d'  /tmp/WifiSSID > /dev/null 
WifiListLine=$(wc -l < /tmp/WifiSSID)

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
            WifiSSID=$(sed -n "${WifiListNumber}"p < /tmp/WifiSSID)
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
rm -rf /tmp/WifiInfo
rm -rf /tmp/WifiSSID






