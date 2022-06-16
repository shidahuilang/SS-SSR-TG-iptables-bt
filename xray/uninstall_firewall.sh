#!/usr/bin/env bash

if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
  debian_package_manager="yum"
elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
  debian_package_manager="apt-get"
elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
  debian_package_manager="apt"
else
  echo -e "\033[31m 不支持该系统 \033[0m"
exit 1
fi
    
echo -e "\033[33m 正在删除防火墙。。。 \033[0m"
ufw disable
$debian_package_manager -y purge firewalld
$debian_package_manager -y purge ufw
systemctl stop firewalld
systemctl disable firewalld
$redhat_package_manager -y remove firewalld
echo -e "\033[32m 正在删除阿里云盾和腾讯云盾 (仅对阿里云和腾讯云服务器有效)。。。 \033[0m"
#阿里云盾
pkill -9 assist_daemon
rm -rf /usr/local/share/assist-daemon
systemctl stop CmsGoAgent
systemctl disable CmsGoAgent
systemctl stop cloudmonitor
/etc/rc.d/init.d/cloudmonitor remove
rm -rf /usr/local/cloudmonitor
rm -rf /etc/systemd/system/CmsGoAgent.service
systemctl daemon-reload
#aliyun-assist
systemctl stop AssistDaemon
systemctl disable AssistDaemon
systemctl stop aliyun
systemctl disable aliyun
$debian_package_manager -y purge aliyun-assist
$redhat_package_manager -y remove aliyun_assist
rm -rf /usr/local/share/aliyun-assist
rm -rf /usr/sbin/aliyun_installer
rm -rf /usr/sbin/aliyun-service
rm -rf /usr/sbin/aliyun-service.backup
rm -rf /etc/systemd/system/aliyun.service
rm -rf /etc/systemd/system/AssistDaemon.service
systemctl daemon-reload
#AliYunDun aegis
pkill -9 AliYunDunUpdate
pkill -9 AliYunDun
pkill -9 AliHids
/etc/init.d/aegis uninstall
rm -rf /usr/local/aegis
rm -rf /etc/init.d/aegis
rm -rf /etc/rc2.d/S80aegis
rm -rf /etc/rc3.d/S80aegis
rm -rf /etc/rc4.d/S80aegis
rm -rf /etc/rc5.d/S80aegis

#腾讯云盾
/usr/local/qcloud/stargate/admin/uninstall.sh
/usr/local/qcloud/YunJing/uninst.sh
/usr/local/qcloud/monitor/barad/admin/uninstall.sh
systemctl daemon-reload
systemctl stop YDService
systemctl disable YDService
rm -rf /lib/systemd/system/YDService.service
systemctl daemon-reload
systemctl stop tat_agent
systemctl disable tat_agent
rm -rf /etc/systemd/system/tat_agent.service
systemctl daemon-reload
sed -i 's#/usr/local/qcloud#rcvtevyy4f5d#g' /etc/rc.local
sed -i '/rcvtevyy4f5d/d' /etc/rc.local
rm -rf $(find /etc/udev/rules.d -iname "*qcloud*" 2>/dev/null)
pkill -9 watchdog.sh
pkill -9 secu-tcs-agent
pkill -9 YDService
pkill -9 YDLive
pkill -9 sgagent
pkill -9 tat_agent
pkill -9 /usr/local/qcloud
pkill -9 barad_agent
kill -s 9 "$(ps -aux | grep '/usr/local/qcloud/nv//nv_driver_install_helper\.sh' | awk '{print $2}')"
rm -rf /usr/local/qcloud
rm -rf /usr/local/sa
rm -rf /usr/local/yd.socket.client
rm -rf /usr/local/yd.socket.server
mkdir /usr/local/qcloud
mkdir /usr/local/qcloud/action
mkdir /usr/local/qcloud/action/login_banner.sh
mkdir /usr/local/qcloud/action/action.sh
if [[ "$(type -P uname)" ]] && uname -a | grep solaris >/dev/null; then
  crontab -l | sed "/qcloud/d" | crontab --
else
  crontab -l | sed "/qcloud/d" | crontab -
fi
exit 0
