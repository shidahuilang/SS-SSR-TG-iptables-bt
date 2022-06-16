#!/bin/bash

# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
ERROR="${Red}[ERROR]${Font}"
arch=$(arch)

function print_ok() {
  echo
  echo -e " ${OK} ${Blue} $1 ${Font}"
  echo
}
function print_error() {
  echo
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
  echo
}
function ECHOY()
{
  echo
  echo -e "${Yellow} $1 ${Font}"
  echo
}
function ECHOG()
{
  echo
  echo -e "${Green} $1 ${Font}"
  echo
}
function ECHOR()
{
  echo
  echo -e "${Red} $1 ${Font}"
  echo
}
judge() {
  if [[ 0 -eq $? ]]; then
    print_ok "$1 完成"
    sleep 1
  else
    print_error "$1 失败"
    exit 1
  fi
}


if [[ ! "$USER" == "root" ]]; then
  print_error "警告：请使用root用户操作!~~"
  exit 1
fi
if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
  ARCH_PRINT="linux64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
  ARCH_PRINT="aarch64"
else
  print_error "不支持此系统,只支持x86_64和arm64的系统"
  exit 1
fi

function system_check() {
  clear
  echo
  echo
  echo -e "\033[32m 有域名用域名,无域名用当前服务器IP \033[0m"
  ECHOY "[比如：v2.clash.com 或 192.168.2.2]"
  export YUMINGIP="请输入"
  while :; do
  CUrrenty=""
  read -p " ${YUMINGIP}：" CUrrent_ip
  if [[ -n "${CUrrent_ip}" ]] && [[ "$(echo ${CUrrent_ip} |grep -c '.')" -ge '1' ]]; then
    CUrrenty="Y"
  fi
  case $CUrrenty in
  Y)
    export CUrrent_ip="$(echo "${CUrrent_ip}" |sed 's/http:\/\///g' |sed 's/https:\/\///g' |sed 's/\///g')"
    export current_ip="http://${CUrrent_ip}"
    export after_ip="http://127.0.0.1"
    ECHOG "您当前服务器IP/域名为：${CUrrent_ip}"
  break
  ;;
  *)
    export YUMINGIP="敬告,请输入正确的域名或IP"
  ;;
  esac
  done

  ECHOY "正在安装各种必须依赖"
  echo
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
    yum upgrade -y libmodulemd
    yum install -y wget curl sudo git lsof tar systemd
    curl -sL https://rpm.nodesource.com/setup_12.x | bash -
    curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
    wget -N -P /etc/yum.repos.d/ https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/xray/nginx.repo
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
    yum update -y
    yum install -y nodejs
    npm install -g yarn
    export INS="yum install -y"
    export PUBKEY="centos"
    export Subcon="/etc/rc.d/init.d/subconverter"
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    echo "
    https://dl-cdn.alpinelinux.org/alpine/v3.12/main
    https://dl-cdn.alpinelinux.org/alpine/v3.12/community
    " > /etc/apk/repositories
    sed -i 's/^[ ]*//g' /etc/apk/repositories
    sed -i '/^$/d' /etc/apk/repositories
    apk update
    apk del yarn nodejs
    apk add git nodejs yarn sudo wget lsof tar npm
    export INS="apk add"
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
    export INS="apt-get install -y"
    export UNINS="apt-get remove -y"
    export PUBKEY="ubuntu"
    export Subcon="/etc/init.d/subconverter"
    nodejs_install
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
    export INS="apt install -y"
    export UNINS="apt remove -y"
    export PUBKEY="debian"
    export Subcon="/etc/init.d/subconverter"
    nodejs_install
  else
    echo -e "\033[31m 不支持该系统 \033[0m"
    exit 1
  fi
}

function nodejs_install() {
    apt update
    ${INS} curl wget sudo git lsof tar systemd lsb-release gnupg2
    ${UNINS} --purge npm
    ${UNINS} --purge nodejs
    ${UNINS} --purge nodejs-legacy
    apt autoremove -y
    curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
    ${UNINS} cmdtest
    ${UNINS} yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    rm -f /etc/apt/sources.list.d/nginx.list
    echo "deb http://nginx.org/packages/${PUBKEY} $(lsb_release -cs) nginx" >/etc/apt/sources.list.d/nginx.list
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
    apt-get update
    ${INS} nodejs yarn
}

function nginx_install() {
  if ! command -v nginx >/dev/null 2>&1; then
    ${INS} nginx
  else
    print_ok "Nginx 已存在"
    rm -fr /etc/nginx/conf.d/clash_nginx.conf > /dev/null 2>&1
    ${INS} nginx >/dev/null 2>&1
  fi
  
  if [[ -d /etc/nginx/sites-available ]]; then
    sub_path="/etc/nginx/sites-available/clash_nginx.conf"
  elif [[ -d /etc/nginx/http.d ]]; then  
    sub_path="/etc/nginx/http.d/clash_nginx.conf"
  else
    mkdir -p /etc/nginx/conf.d >/dev/null 2>&1
    sub_path="/etc/nginx/conf.d/clash_nginx.conf"
  fi
cat >"${sub_path}" <<-EOF
server {
    listen 80;
    server_name ${CUrrent_ip};

    root /www/dist_web;
    index index.html index.htm;

    error_page 404 /index.html;

    gzip on; #开启gzip压缩
    gzip_min_length 1k; #设置对数据启用压缩的最少字节数
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 6; #设置数据的压缩等级,等级为1-9，压缩比从小到大
    gzip_types text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml; #设置需要压缩的数据格式
    gzip_vary on;

    location ~* \.(css|js|png|jpg|jpeg|gif|gz|svg|mp4|ogg|ogv|webm|htc|xml|woff)$ {
        access_log off;
        add_header Cache-Control "public,max-age=30*24*3600";
    }
}
EOF
service nginx restart
}

function command_Version() {
  if [[ ! -x "$(command -v node)" ]]; then
    print_error "node安装失败!"
    exit 1
  else
    node_version="$(node --version |egrep -o 'v[0-9]+\.[0-9]+\.[0-9]+')"
    print_ok "node版本号为：${node_version}"
  fi
  if [[ ! -x "$(command -v yarn)" ]]; then
    print_error "yarn安装失败!"
    exit 1
  else
    yarn_version="$(yarn --version |egrep -o '[0-9]+\.[0-9]+\.[0-9]+')"
    print_ok "yarn版本号为：${yarn_version}"
  fi
  if [[ ! -x "$(command -v nginx)" ]]; then
    print_error "nginx安装失败!"
    exit 1
  else
    nginxVersion="$(nginx -v 2>&1)" && NGINX_VERSION="$(echo ${nginxVersion#*/})"
    print_ok "Nginx版本号为：${NGINX_VERSION}"
  fi
}

function port_exist_check() {
  if [[ 0 -eq $(lsof -i:"25500" | grep -i -c "listen") ]]; then
    print_ok "25500 端口未被占用"
    sleep 1
  else
    ECHOR "检测到 25500 端口被占用，以下为 25500 端口占用信息"
    lsof -i:"25500"
    ECHOR "5s 后将尝试自动清理占用进程"
    sleep 5
    lsof -i:"25500" | awk '{print $2}' | grep -v "PID" | xargs kill -9
    print_ok "25500端口占用进程清理完成"
    sleep 1
  fi
}

function install_subconverter() {
  ECHOY "正在安装subconverter服务"
  find / -name 'subconverter' 2>&1 | xargs -i rm -rf {}
  if [[ -x "$(command -v docker)" ]]; then
    if [[ `docker images | grep -c "subconverter"` -ge '1' ]] || [[ `docker ps -a | grep -c "subconverter"` -ge '1' ]]; then
      ECHOY "检测到subconverter服务存在，正在御载subconverter服务，请稍后..."
      dockerid="$(docker ps -a |grep 'subconverter' |awk '{print $1}')"
      imagesid="$(docker images |grep 'subconverter' |awk '{print $3}')"
      docker stop -t=5 "${dockerid}" > /dev/null 2>&1
      docker rm "${dockerid}"
      docker rmi "${imagesid}"
      if [[ `docker ps -a | grep -c "subconverter"` == '0' ]] && [[ `docker images | grep -c "subconverter"` == '0' ]]; then
        print_ok "subconverter御载完成"
      else
        print_error "subconverter御载失败"
        exit 1
      fi
    fi  
  fi
  latest_vers="$(wget -qO- -t1 -T2 "https://api.github.com/repos/tindy2013/subconverter/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')"
  [[ -z ${latest_vers} ]] && latest_vers="v0.7.2"
  rm -rf "/root/subconverter_${ARCH_PRINT}.tar.gz" >/dev/null 2>&1
  wget https://ghproxy.com/https://github.com/tindy2013/subconverter/releases/download/${latest_vers}/subconverter_${ARCH_PRINT}.tar.gz
  if [[ $? -ne 0 ]];then
    echo -e "\033[31m subconverter下载失败! \033[0m"
    exit 1
  fi
  tar -zxvf subconverter_${ARCH_PRINT}.tar.gz
  if [[ $? -ne 0 ]];then
    echo -e "\033[31m subconverter解压失败! \033[0m"
    exit 1
  else
    echo -e "\033[32m subconverter解压成功! \033[0m"
    cp /root/subconverter/pref.example.ini /root/subconverter/pref.ini
    export HDPASS="$(cat /proc/sys/kernel/random/uuid)"
    sed -i "s?${after_ip}?${current_ip}?g" "/root/subconverter/pref.ini"
    sed -i "s?api_access_token=password?api_access_token=${HDPASS}?g" "/root/subconverter/pref.ini"
  fi
  rm -rf "/root/subconverter_${ARCH_PRINT}.tar.gz"
 }

function update_rc() {
  pm2 delete subconverter >/dev/null 2>&1
  if [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    rc-update add nginx boot
    pm2 start /root/subconverter/subconverter -n subconverter
    echo "@reboot pm2 start /root/subconverter/subconverter -n subconverter" >> "/etc/crontabs/root"
  else
    systemctl enable nginx
    echo '
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
    ' > /etc/systemd/system/subconverter.service
    sed -i 's/^[ ]*//g' /etc/systemd/system/subconverter.service
    sed -i '1d' /etc/systemd/system/subconverter.service
    chmod 755 /etc/systemd/system/subconverter.service
    sleep 2
    systemctl daemon-reload
    systemctl start subconverter
    systemctl enable subconverter
  fi
  if [[ $(lsof -i:"25500" | grep -i -c "listen") -ge "1" ]]; then
    print_ok "subconverter安装成功"
  else
    print_error "subconverter安装失败,请再次执行安装命令试试"
    exit 1
  fi
 }

function install_subweb() {
  ECHOY "正在安装sub-web服务"
  rm -fr sub-web && git clone https://ghproxy.com/https://github.com/CareyWang/sub-web.git sub-web
  if [[ $? -ne 0 ]];then
    echo -e "\033[31m sub-web下载失败,请再次执行安装命令试试! \033[0m"
    exit 1
  else
    rm -fr "subweb" && git clone https://ghproxy.com/https://github.com/shidahuilang/SS-SSR-TG-iptables-bt "subweb"
    judge "sub-web补丁下载"
    cp -R subweb/subweb/* "sub-web/"
    mv -f "subweb/subweb/.env" "sub-web/.env"
    wget -q https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/Subconverter.vue -O /root/sub-web/src/views/Subconverter.vue
    if [[ $? -ne 0 ]]; then
      curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/Subconverter.vue > "/root/sub-web/src/views/Subconverter.vue"
    fi
    rm -fr "subweb"
    cd "sub-web"
    sed -i "s?${after_ip}?${current_ip}?g" "/root/sub-web/.env"
    sed -i "s?${after_ip}?${current_ip}?g" "/root/sub-web/src/views/Subconverter.vue"
    yarn install
    yarn build
    if [[ -d /root/sub-web/dist ]]; then
      [[ ! -d /www/dist_web ]] && mkdir -p /www/dist_web || rm -rf /www/dist_web/*
      cp -R /root/sub-web/dist/* /www/dist_web/
    else
      print_error "生成页面文件失败,请再次执行安装命令试试"
      exit 1
    fi
  fi

  print_ok "sub-web安装完成"
    
  ECHOY "全部服务安装完毕,请登录 ${current_ip} 进行使用"
}


menu2() {
  ECHOG "subconverter已存在，是否要御载subconverter[Y/n]?"
  export DUuuid="请输入[Y/y]确认或[N/n]退出"
  while :; do
  read -p " ${DUuuid}：" IDPATg
  case $IDPATg in
  [Yy])
    ECHOY "开始御载subconverter"
    systemctl stop subconverter
    systemctl disable subconverter
    systemctl daemon-reload
    rm -rf /root/subconverter
    rm -rf /root/sub-web
    rm -rf /www/dist_web
    rm -rf /etc/systemd/system/subconverter.service
    rm -rf /etc/nginx/sites-available/clash_nginx.conf
    print_ok "subconverter御载完成"
  break
  ;;
  [Nn])
   exit 1
  break
  ;;
  *)
    export DUuuid="请正确输入[Y/y]确认或[N/n]退出"
  ;;
  esac
  done
}

menu() {
  system_check
  nginx_install
  command_Version
  port_exist_check
  install_subconverter
  update_rc
  install_subweb
}

if [[ -d /root/subconverter ]]; then
  systemctl start subconverter > /dev/null 2>&1
  sleep 2
  if [[ `systemctl status nginx |grep -c "active (running) "` == '1' ]]; then
    menu2 "$@"
  else
    menu "$@"
  fi
else
  menu "$@"
fi
