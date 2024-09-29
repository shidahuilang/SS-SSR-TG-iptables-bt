#!/usr/bin/env bash

#====================================================
#	System Request:Debian 9+/Ubuntu 18.04+/Centos 7+
#	Author:	wulabing
#	Dscription: Xray onekey Management
#	email: admin@wulabing.com
#====================================================

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
stty erase ^?

cd "$(
  cd "$(dirname "$0")" || exit
  pwd
)" || exit

# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
Hi="${Green}[Hi]${Font}"
ERROR="${Red}[ERROR]${Font}"

# 变量
github_branch="main"
xray_conf_dir="/usr/local/x-ui"
website_dir="/www/xray_web/"
xray_access_log="/var/log/xray/access.log"
xray_error_log="/var/log/xray/error.log"
cert_dir="/usr/local/x-ui"
domain_tmp_dir="/usr/local/x-ui"
cert_group="nobody"
random_num=$((RANDOM % 12 + 4))
HOME="/root"

function print_ok() {
  echo -e " ${OK} ${Blue} $1 ${Font}"
}
function print_Hi() {
  echo -e " ${Hi} ${Blue} $1 ${Font}"
}
function print_error() {
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
}
function ECHOY()
{
  echo -e "${Yellow} $1 ${Font}"
}
function ECHOG()
{
  echo -e "${Green} $1 ${Font}"
}
function is_root() {
  if [[ 0 == "$UID" ]]; then
    print_ok "当前用户是 root 用户，请开始您的骚操作"
  else
    print_error "当前用户不是 root 用户，请切换到 root 用户后重新执行脚本"
    exit 1
  fi
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

function running_state() {
  nginxVersion="$(nginx -v 2>&1)" && NGINX_VERSION="$(echo ${nginxVersion#*/})"
  if [[ `command -v x-ui |grep -c "x-ui"` == '0' ]]; then
    export XUI_ZT="${Blue} x-ui状态${Font}：${Red}未安装${Font}"
  elif [[ `systemctl status x-ui |grep -c "active (running) "` == '1' ]]; then
    export XUI_ZT="${Blue} x-ui状态${Font}：${Green}运行中 ${Font}|${Blue} 版本${Font}：${Green}v0.3.2${Font}"
  elif [[ `command -v x-ui |grep -c "x-ui"` -ge '1' ]] && [[ `systemctl status cloudreve |grep -c "active (running) "` == '0' ]]; then
    export XUI_ZT="${Blue} x-ui状态${Font}：${Green}已安装${Font},${Red}未运行${Font}"
  else
    export XUI_ZT="${Blue} x-ui状态：${Font}未知"
  fi

  if [[ `command -v nginx |grep -c "nginx"` == '0' ]]; then
    export NGINX_ZT="${Blue} Nginx状态${Font}：${Red}未安装${Font}"
  elif [[ `systemctl status nginx |grep -c "active (running) "` == '1' ]]; then
    export NGINX_ZT="${Blue} Nginx状态${Font}：${Green}运行中 ${Font}|${Blue} 版本${Font}：${Green}v${NGINX_VERSION}${Font}"
  elif [[ `command -v nginx |grep -c "nginx"` -ge '1' ]] && [[ `systemctl status nginx |grep -c "active (running) "` == '0' ]]; then
    export NGINX_ZT="${Blue} Nginx状态${Font}：${Green}已安装${Font},${Red}未运行${Font}"
  else
    export NGINX_ZT="${Blue} Nginx状态：${Font}未知"
  fi
}

function system_check() {
  source '/etc/os-release'

  if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
    print_ok "当前系统为 Centos ${VERSION_ID} ${VERSION}"
    export INS="yum install -y"
    ${INS} socat wget ca-certificates && update-ca-trust force-enable
    wget -N -P /etc/yum.repos.d/ https://raw.githubusercontent.com/281677160/agent/main/xray/nginx.repo
  elif [[ "${ID}" == "ol" ]]; then
    print_ok "当前系统为 Oracle Linux ${VERSION_ID} ${VERSION}"
    export INS="yum install -y"
    ${INS} wget
    wget -N -P /etc/yum.repos.d/ https://raw.githubusercontent.com/281677160/agent/main/xray/nginx.repo
  elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 9 ]]; then
    print_ok "当前系统为 Debian ${VERSION_ID} ${VERSION}"
    export INS="apt install -y"
    ${INS} socat wget ca-certificates && update-ca-certificates
    # 清除可能的遗留问题
    rm -f /etc/apt/sources.list.d/nginx.list
    $INS lsb-release gnupg2

    echo "deb http://nginx.org/packages/debian $(lsb_release -cs) nginx" >/etc/apt/sources.list.d/nginx.list
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

    apt update
  elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 18 ]]; then
    print_ok "当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME}"
    export INS="apt install -y"
    ${INS} socat wget ca-certificates && update-ca-certificates
    # 清除可能的遗留问题
    rm -f /etc/apt/sources.list.d/nginx.list
    $INS lsb-release gnupg2

    echo "deb http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" >/etc/apt/sources.list.d/nginx.list
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
    apt update
  else
    print_error "当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内"
    exit 1
  fi

  if [[ $(grep "nogroup" /etc/group) ]]; then
    cert_group="nogroup"
  fi

  $INS dbus

  # 关闭各类防火墙
  systemctl stop firewalld
  systemctl disable firewalld
  systemctl stop nftables
  systemctl disable nftables
  systemctl stop ufw
  systemctl disable ufw
}

function kaishi_install() {
  echo
  echo
  export YUMING="请输入您的域名"
  ECHOY "${YUMING}[比如：v2.xray.com]"
  while :; do
  read -p " ${YUMING}：" domain
  if [[ -n "${domain}" ]] && [[ "$(echo ${domain} |grep -c '\.')" -ge '1' ]]; then
    export domainy="Y"
  fi
  case $domainy in
  Y)
    export domain="${domain}"
  break
  ;;
  *)
    export YUMING="敬告：请输入正确的域名"
  ;;
  esac
  done
  echo
  ECHOG "您的域名为：${domain}"
  echo
  read -p " [检查是否正确,正确回车继续,不正确按Q回车重新输入]： " NNKC
  case $NNKC in
  [Qq])
    install_xui
    exit 0
  ;;
  *)
    echo
    print_ok "您已确认无误!"
  ;;
  esac
  echo
  ECHOY "开始执行安装程序,请耐心等候..."
  sleep 2
  echo
}

function nginx_install() {
  if ! command -v nginx >/dev/null 2>&1; then
    ${INS} nginx
    judge "Nginx 安装"
  else
    print_ok "Nginx 已存在"
    ${INS} nginx
  fi
  # 遗留问题处理
  mkdir -p /etc/nginx/conf.d >/dev/null 2>&1
}
function dependency_install() {
  ${INS} lsof tar
  judge "安装 lsof tar"

  if [[ "${ID}" == "centos" || "${ID}" == "ol" ]]; then
    ${INS} crontabs
  else
    ${INS} cron
  fi
  judge "安装 crontab"

  if [[ "${ID}" == "centos" || "${ID}" == "ol" ]]; then
    touch /var/spool/cron/root && chmod 600 /var/spool/cron/root
    systemctl start crond && systemctl enable crond
  else
    touch /var/spool/cron/crontabs/root && chmod 600 /var/spool/cron/crontabs/root
    systemctl start cron && systemctl enable cron
  fi
  judge "crontab 自启动配置 "

  ${INS} unzip
  judge "安装 unzip"

  # upgrade systemd
  ${INS} systemd
  judge "安装/升级 systemd"

  # Nginx 后置 无需编译 不再需要
  #  if [[ "${ID}" == "centos" ||  "${ID}" == "ol" ]]; then
  #    yum -y groupinstall "Development tools"
  #  else
  #    ${INS} build-essential
  #  fi
  #  judge "编译工具包 安装"

  if [[ "${ID}" == "centos" ]]; then
    ${INS} pcre pcre-devel zlib-devel epel-release openssl openssl-devel
  elif [[ "${ID}" == "ol" ]]; then
    ${INS} pcre pcre-devel zlib-devel openssl openssl-devel
    # Oracle Linux 不同日期版本的 VERSION_ID 比较乱 直接暴力处理。如出现问题或有更好的方案，请提交 Issue。
    yum-config-manager --enable ol7_developer_EPEL >/dev/null 2>&1
    yum-config-manager --enable ol8_developer_EPEL >/dev/null 2>&1
  else
    ${INS} libpcre3 libpcre3-dev zlib1g-dev openssl libssl-dev
  fi

  ${INS} jq

  if ! command -v jq; then
    wget -P /usr/bin https://raw.githubusercontent.com/281677160/agent/main/xray/jq && chmod +x /usr/bin/jq
    judge "安装 jq"
  fi

  # 防止部分系统xray的默认bin目录缺失
  mkdir /usr/local/bin >/dev/null 2>&1
}

function basic_optimization() {
  # 最大文件打开数
  sed -i '/^\*\ *soft\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
  sed -i '/^\*\ *hard\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
  echo '* soft nofile 65536' >>/etc/security/limits.conf
  echo '* hard nofile 65536' >>/etc/security/limits.conf

  # RedHat 系发行版关闭 SELinux
  if [[ "${ID}" == "centos" || "${ID}" == "ol" ]]; then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    setenforce 0
  fi
}

function domain_check() {
  export domain_ip="$(ping "${domain}" -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')" > /dev/null 2>&1
  export local_ip=$(curl -4L api64.ipify.org)
  print_ok "检测域名解析"
  if [[ ! ${local_ip} == ${domain_ip} ]]; then
    echo
    ECHOY "域名解析IP为：${domain_ip}"
    echo
    ECHOY "本机IP为：${local_ip}"
    echo
    print_error "域名解析IP跟本机IP不一致"
    exit 1
  else
    print_ok "域名解析IP为：${domain_ip}"
    print_ok "本机IP为：${local_ip}"
    print_ok "域名解析IP跟本机IP一致"
  fi
}

function port_exist_check() {
  if [[ 0 -eq $(lsof -i:"$1" | grep -i -c "listen") ]]; then
    print_ok "$1 端口未被占用"
    sleep 1
  else
    print_error "检测到 $1 端口被占用，以下为 $1 端口占用信息"
    lsof -i:"$1"
    print_error "5s 后将尝试自动 kill 占用进程"
    sleep 5
    lsof -i:"$1" | awk '{print $2}' | grep -v "PID" | xargs kill -9
    print_ok "kill 完成"
    sleep 1
  fi
}

function xui_install() {
print_ok "安装 x-ui"
cd /root
arch=$(uname -m)

if [ "$arch" == "x86_64" ]; then
    latest_ver="$(wget -qO- -t1 -T2 "https://api.github.com/repos/vaxilu/x-ui/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')"
    wget -q -P /root https://github.com/vaxilu/x-ui/releases/download/${latest_ver}/x-ui-linux-amd64.tar.gz -O /root/x-ui-linux-amd64.tar.gz
else
    latest_ver="$(wget -qO- -t1 -T2 "https://api.github.com/repos/vaxilu/x-ui/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')"
    wget -q -P /root https://github.com/vaxilu/x-ui/releases/download/${latest_ver}/x-ui-linux-arm64.tar.gz -O /root/x-ui-linux-arm64.tar.gz
fi

judge "x-ui 文件下载"
rm -rf x-ui/ /usr/local/x-ui/ /usr/bin/x-ui
if [ "$arch" == "x86_64" ]; then
    tar zxvf x-ui-linux-amd64.tar.gz
else
    tar zxvf x-ui-linux-arm64.tar.gz
fi

judge "x-ui 文件解压"
chmod +x x-ui/x-ui x-ui/bin/xray-linux-* x-ui/x-ui.sh
cp x-ui/x-ui.sh /usr/bin/x-ui
cp -f x-ui/x-ui.service /etc/systemd/system/
mv x-ui/ /usr/local/
systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui
rm -rf /root/x-ui-linux-amd64.tar.gz /root/x-ui-linux-arm64.tar.gz
judge "x-ui 安装"

}

function configure_nginx() {
  nginx_conf="/etc/nginx/conf.d/${domain}.conf"
  cd /etc/nginx/conf.d/ && rm -f ${domain}.conf && wget -O ${domain}.conf https://raw.githubusercontent.com/281677160/agent/main/xray/web.conf
  sed -i "s/xxx/${domain}/g" ${nginx_conf}
  judge "Nginx 配置 修改"

  systemctl restart nginx
}

function generate_certificate() {
  signedcert=$(xray tls cert -domain="$local_ip" -name="$local_ip" -org="$local_ip" -expire=87600h)
  echo $signedcert | jq '.certificate[]' | sed 's/\"//g' | tee $cert_dir/self_signed_cert.pem
  echo $signedcert | jq '.key[]' | sed 's/\"//g' >$cert_dir/self_signed_key.pem
  openssl x509 -in $cert_dir/self_signed_cert.pem -noout || 'print_error "生成自签名证书失败" && exit 1'
  print_ok "生成自签名证书成功"
  chown nobody.$cert_group $cert_dir/self_signed_cert.pem
  chown nobody.$cert_group $cert_dir/self_signed_key.pem
}

function ssl_judge_and_install() {
  [[ ! -d /ssl ]] && mkdir -p /ssl
  if [[ -f "$HOME/.acme.sh/${domain}_ecc/${domain}.key" && -f "$HOME/.acme.sh/${domain}_ecc/${domain}.cer" && -f "$HOME/.acme.sh/acme.sh" ]]; then
    print_ok "[${domain}]证书已存在，重新启用证书"
    sleep 2
    rm -fr /ssl/* >/dev/null 2>&1
    "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /ssl/xray.crt --keypath /ssl/xray.key --ecc
    judge "证书启用"
    sleep 2
    "$HOME"/.acme.sh/acme.sh --upgrade --auto-upgrade
    echo $domain >"$HOME"/.acme.sh/domainjilu
    judge "域名记录"
  else
    rm -rf /ssl/* > /dev/null 2>&1
    rm -fr "$HOME"/.acme.sh > /dev/null 2>&1
    sed -i '/acme.sh/d' "$HOME"/.bashrc > /dev/null 2>&1
    sed -i '/acme.sh/d' "$HOME"/.cshrc > /dev/null 2>&1
    sed -i '/acme.sh/d' "$HOME"/.tcshrc > /dev/null 2>&1
    cp -a $cert_dir/self_signed_cert.pem /ssl/xray.crt
    cp -a $cert_dir/self_signed_key.pem /ssl/xray.key
    acme
  fi
  chown -R nobody.$cert_group /ssl/*
}

function acme() {
  curl -L get.acme.sh | bash
  judge "安装 SSL 证书生成脚本"
  
  "$HOME"/.acme.sh/acme.sh --set-default-ca --server letsencrypt

  sed -i "6s/^/#/" "$nginx_conf"
  sed -i "6a\\\troot $website_dir;" "$nginx_conf"
  systemctl restart nginx

  if "$HOME"/.acme.sh/acme.sh --issue -d "${domain}" --webroot "$website_dir" -k ec-256 --force; then
    print_ok "SSL 证书生成成功"
    sleep 2
    if "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /ssl/xray.crt --keypath /ssl/xray.key --reloadcmd "systemctl restart x-ui" --ecc --force; then
      print_ok "SSL 证书配置成功"
      "$HOME"/.acme.sh/acme.sh --upgrade --auto-upgrade
      echo $domain >"$HOME"/.acme.sh/domainjilu
      judge "域名记录"
    fi
  else
    print_error "SSL 证书生成失败"
    rm -rf "$HOME/.acme.sh/${domain}_ecc"
    exit 1
  fi

  sed -i "7d" "$nginx_conf"
  sed -i "6s/#//" "$nginx_conf"
}

function restart_all() {
  x-ui enable
  restart_xui
  echo
  ECHOY "1、用浏览器打开此链接： http://${local_ip}:54321"
  ECHOY "2、初始管理员账号：admin"
  ECHOY "3、初始管理员密码：admin"
  ECHOY "4、面板证书公钥文件路径：/ssl/xray.crt"
  ECHOY "5、面板证书密钥文件路径：/ssl/xray.key"
  ECHOY "6、[54321]端口自行修改成其他的"
  ECHOY "7、全部修改完成重启面板后可以用 https://${domain}:端口 访问"
  cat >/ssl/conck <<-EOF
  echo -e "\033[32m面板证书公钥文件路径：\033[0m/ssl/xray.crt"
  echo -e "\033[32m面板证书密钥文件路径：\033[0m/ssl/xray.key"
EOF
}

function restart_xui() {
  systemctl restart nginx
  x-ui restart
  sleep 1
  if [[ `systemctl status nginx |grep -c "active (running) "` == '1' ]]; then
    print_ok "nginx运行 正常"
  else
    print_error "nginx没有运行"
    exit 1
  fi
  if [[ `systemctl status x-ui |grep -c "active (running) "` == '1' ]]; then
    print_ok "x-ui运行 正常"
  else
    print_error "x-ui没有运行"
    exit 1
  fi
}

function xui_uninstall() {
  x-ui stop
  x-ui disable
  x-ui uninstall
  find / -iname 'x-ui' | xargs -i rm -rf {}
  print_ok "x-ui面板御载 完成"
  sleep 2
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]] || [[ "$(. /etc/os-release && echo "$ID")" == "ol" ]]; then
    yum remove nginx -y
  else
    apt-get --purge remove -y nginx
    apt-get autoremove -y
    apt-get --purge remove -y nginx
    apt-get --purge remove -y nginx-common
    apt-get --purge remove -y nginx-core
  fi
  find / -iname 'nginx' | xargs -i rm -rf {}
  print_ok "nginx御载 完成"
  sleep 2
  if [[ -d "$HOME"/.acme.sh ]]; then
    clear
    echo
    [[ -f "$HOME/.acme.sh/domainjilu" ]] && PROFILE="$(cat $HOME/.acme.sh/domainjilu)"
    if [[ -f "$HOME/.acme.sh/${PROFILE}_ecc/${PROFILE}.cer" ]] && [[ -f "$HOME/.acme.sh/${PROFILE}_ecc/${PROFILE}.key" ]]; then
        export TISHI="提示：[ ${PROFILE} ]证书已经存在,如果还继续使用此域名建议勿删除.acme.sh"
     else
        export WUTISHI="Y"
     fi
     if [[ ${WUTISHI} == "Y" ]]; then
        "$HOME"/.acme.sh/acme.sh --uninstall
        rm -rf $HOME/.acme.sh
        rm -rf /ssl/*
        sed -i '/acme.sh/d' /root/.bashrc > /dev/null 2>&1
        sed -i '/acme.sh/d' /root/.cshrc > /dev/null 2>&1
        sed -i '/acme.sh/d' /root/.tcshrc > /dev/null 2>&1
      else
        ECHOY "是否卸载 acme.sh [Y/N]?"
        echo
        ECHOY "${TISHI}"
        echo
        read -p " 输入您的选择：" uninstall_acme
        case $uninstall_acme in
        [yY])
           "$HOME"/.acme.sh/acme.sh --uninstall
           rm -rf "$HOME"/.acme.sh
           rm -rf /ssl/*
           sed -i '/acme.sh/d' /root/.bashrc > /dev/null 2>&1
           sed -i '/acme.sh/d' /root/.cshrc > /dev/null 2>&1
           sed -i '/acme.sh/d' /root/.tcshrc > /dev/null 2>&1
	   print_ok "acme.sh御载 完成"
	   sleep 2
        ;;
        *) 
            print_ok "您已跳过御载acme.sh"
            echo
        ;;
        esac
       fi
    fi
  print_ok "所有卸载程序执行完毕!"
  exit 0
}

function install_xui() {
  is_root
  kaishi_install
  system_check
  dependency_install
  basic_optimization
  domain_check
  port_exist_check 80
  xui_install
  nginx_install
  configure_nginx
  generate_certificate
  ssl_judge_and_install
  restart_all
}
menu() {
  clear
  echo
  echo
  running_state
  echo -e "${XUI_ZT}"
  echo -e "${NGINX_ZT}"
  echo
  ECHOY "1、安装 x-ui面板和nginx"
  ECHOY "2、重启 x-ui面板和nginx"
  ECHOY "3、查询 证书路径"
  ECHOY "4、安装 BBR、锐速加速"
  ECHOY "5、卸载 x-ui面板和nginx"
  ECHOY "6、退出"
  echo
  echo
  XUANZHE="请输入数字"
  while :; do
  read -p " ${XUANZHE}：" menu_num
  case $menu_num in
  1)
    install_xui
    break
    ;;
  2)
    restart_xui
    break
    ;;
  3)
    [[ -f /ssl/conck ]] && source /ssl/conck || ECHOY "无此文件或者没有证书"
    break
    ;;
  4)
    wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
    break
    ;;
  5)
    xui_uninstall
    break
    ;;
  6)
    exit 0
    break
    ;;
    *)
    XUANZHE="请输入正确的选择"
    ;;
  esac
  done
}
menu "$@"
