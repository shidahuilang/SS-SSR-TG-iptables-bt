#!/bin/bash
cd /root
source /root/sub_suc
shopt -s extglob
cd /www/wwwroot/${wzym}
rm -rf !(.user.ini)
cd /root
cp -Rf /root/sub-web/dist/* /www/wwwroot/${wzym}
rm -fr subconverter_linux64.tar.gz
rm -fr subconverter
wget https://github.com/tindy2013/subconverter/releases/download/v0.6.3/subconverter_linux64.tar.gz
if [[ $? -ne 0 ]];then
  echo -e "\033[31m subconverter文件下载失败! \033[0m"
else
  tar -zxvf subconverter_linux64.tar.gz
fi
chmod +x /root/subconverter/pref.ini
Api2="api_access_token\=$(date +e%Swoid%YiI6IC%dIyIiwK%HInBz%MIjogIjIzM3Y)"
Api1="$(cat /root/subconverter/pref.ini |grep "api_access_token=")"
sed -i "s/${Api1}/${Api2}/g" /root/subconverter/pref.ini
Managed2="managed_config_prefix\=https:\/\/${fwym}"
Managed1="$(cat /root/subconverter/pref.ini |grep "managed_config_prefix=" |sed 's/\//\\&/g')"
sed -i "s/${Managed1}/${Managed2}/g" /root/subconverter/pref.ini
List2="listen\=127.0.0.1"
List1="$(cat /root/subconverter/pref.ini |grep "listen=")"
sed -i "s/${List1}/${List2}/g" /root/subconverter/pref.ini
rm -fr /root/sub_suc
rm -fr /root/subconverter_linux64.tar.gz
[[ ! -d /etc/systemd/system ]] && mkdir -p /etc/systemd/system
cat >/etc/systemd/system/sub.service <<-EOF
[Unit]
Description=A API For Subscription Convert
After=network.target
 
[Service]
Type=simple
ExecStart=/root/subconverter/subconverter
WorkingDirectory=/root/subconverter
Restart=always
RestartSec=10
 
[Install]
WantedBy=multi-user.target
EOF
chmod +x /etc/systemd/system/sub.service
systemctl daemon-reload
systemctl start sub
systemctl enable sub
systemctl status sub
echo -e "\033[32m 安装完成,按 Ctrl+C退出! \033[0m"
exit 0
