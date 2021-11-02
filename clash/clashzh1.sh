#!/bin/bash

if [[ ! "$USER" == "root" ]]; then
	clear
	echo
	echo -e "\033[31m 警告：请使用root用户操作!~~ \033[0m"
	echo
	sleep 2
	exit 1
fi
if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
	curl -sL https://rpm.nodesource.com/setup_12.x | bash -
	export AZML="sudo yum install"
elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	export AZML="sudo apt-get install"
elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
	curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
	export AZML="sudo apt install"
else
	echo -e "\033[31m 不支持该系统 \033[0m"
	exit 1
fi
clear
echo
echo -e "\033[33m 请输入您的前端网页域名[比如：wy.v2ray.com] \033[0m"
read -p " 请输入您的前端网页域名：" wzym
export wzym="${wzym}"
echo -e "\033[32m 您的前端网页域名为：${wzym} \033[0m"
echo
sleep 3
echo
echo -e "\033[33m 请输入您的后端服务器地址域名[比如：fwq.v2ray.com] \033[0m"
read -p " 请输入您的后端服务器地址域名：" fwym
export fwym="${fwym}"
echo -e "\033[32m 您的后端服务器地址域名为：${fwym} \033[0m"
echo
sleep 3
cat >/root/sub_suc <<-EOF
wzym=${wzym}
fwym=${fwym}
EOF
${AZML} -y nodejs
if [[ `node --version |egrep -o "v[0-9]+\.[0-9]+\.[0-9]+"` ]]; then
	echo ""
else
	echo -e "\033[31m node安装失败! \033[0m"
  exit 1
fi
if [[ `npm --version |egrep -o "[0-9]+\.[0-9]+\.[0-9]+"` ]]; then
	echo ""
else
	echo -e "\033[31m npm安装失败! \033[0m"
  exit 1
fi
npm install -g yarn
if [[ `yarn --version |egrep -o "[0-9]+\.[0-9]+\.[0-9]+"` ]]; then
	echo ""
else
	echo -e "\033[31m yarn安装失败! \033[0m"
  exit 1
fi
rm -fr sub-web && git clone https://github.com/CareyWang/sub-web.git
if [[ $? -ne 0 ]];then
	echo -e "\033[31m sub-web下载失败! \033[0m"
	exit 1
else
	cd sub-web
	yarn install
	yarn serve
fi
exit 0
