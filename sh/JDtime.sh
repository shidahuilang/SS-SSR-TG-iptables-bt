#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

apt -y install unzip >> /dev/null 2>&1 || yum install  unzip -y >> /dev/null 2>&1
rm besttrace*
# install besttrace
if [ ! -f "besttrace" ]; then
    wget https://cdn.ipip.net/17mon/besttrace4linux.zip
    unzip besttrace4linux.zip
    rm besttrace4linux.zip
fi
arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
  chmod +x besttrace
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
  rm besttrace && mv besttracearm besttrace && chmod +x besttrace
else
  arch="amd64"
  echo -e "${red}检测架构失败，使用默认架构: ${arch}${plain}"
fi
echo "架构: ${arch}"
## start to use besttrace

next() {
    printf "%-70s\n" "-" | sed 's/\s/-/g'
}

clear
next

ip_list=(202.103.44.150 14.215.116.1 101.95.120.109 117.28.254.129 113.207.25.138 119.6.6.6 120.204.197.126 183.221.253.100 202.112.14.151)
ip_addr=(武汉电信 广州电信 上海电信 厦门电信 重庆联通 成都联通 上海移动 成都移动 成都教育网)
# ip_len=${#ip_list[@]}

for i in {0..8}
do
	echo ${ip_addr[$i]}
	./besttrace -q 1 ${ip_list[$i]}
	next
done
#清理besttrace相关文件
rm besttrace*
