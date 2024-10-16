#!/usr/bin/env bash

#====================================================
# Author：dahuilang
# Dscription：Xary onekey Management
# github：https://github.com/shidahuilang
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
xray_conf_dir="/usr/local/etc/xray"
website_dir="/www/xray_web/"
xray_access_log="/var/log/xray/access.log"
xray_error_log="/var/log/xray/error.log"
cert_dir="/usr/local/etc/xray"
domain_tmp_dir="/usr/local/etc/xray"
cloudreve_path="/usr/local/cloudreve"
cloudreve_service="/etc/systemd/system"
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
  [[ -f '/usr/local/bin/xray' ]] && XRAY_VERSION="$(/usr/local/bin/xray -version | awk 'NR==1 {print $2}')"
  nginxVersion="$(nginx -v 2>&1)" && NGINX_VERSION="$(echo ${nginxVersion#*/})"
  [[ -f '/usr/local/cloudreve/latest_ver' ]] && CLOUDREVE_VERSION="$(cat /usr/local/cloudreve/latest_ver)"
  if [[ `command -v xray |grep -c "xray"` == '0' ]]; then
    export XRAY_ZT="${Blue} Xray状态${Font}：${Red}未安装${Font}"
  elif [[ `systemctl status xray |grep -c "active (running) "` == '1' ]]; then
    export XRAY_ZT="${Blue} Xray状态${Font}：${Green}运行中 ${Font}|${Blue} 版本${Font}：${Green}v${XRAY_VERSION}${Font}"
  elif [[ `command -v xray |grep -c "xray"` -ge '1' ]] && [[ `systemctl status xray |grep -c "active (running) "` == '0' ]]; then
    export XRAY_ZT="${Blue} Xray状态${Font}：${Green}已安装${Font},${Red}未运行${Font}"
  else
    export XRAY_ZT="${Blue} Xray状态：${Font}未知"
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

  if [[ ! -f ${cloudreve_path}/cloudreve.db ]] && [[ ! -f ${cloudreve_path}/cloudreve ]]; then
    export CLOUDREVE_ZT="${Blue} Cloudreve状态${Font}：${Red}未安装${Font}"
  elif [[ -f ${cloudreve_path}/cloudreve.db ]] && [[ `systemctl status cloudreve |grep -c "active (running) "` == '1' ]]; then
    export CLOUDREVE_ZT="${Blue} Cloudreve状态${Font}：${Green}运行中 ${Font}|${Blue} 版本${Font}：${Green}v${CLOUDREVE_VERSION}${Font}"
  elif [[ -f ${cloudreve_path}/cloudreve.db ]] && [[ `systemctl status cloudreve |grep -c "active (running) "` == '0' ]]; then
    export CLOUDREVE_ZT="${Blue} Cloudreve状态${Font}：${Green}已安装${Font},${Red}未运行${Font}"
  else
    export CLOUDREVE_ZT="${Blue} Cloudreve状态：${Font}未知"
  fi
}

function system_check() {
  source '/etc/os-release'

  if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
    print_ok "当前系统为 Centos ${VERSION_ID} ${VERSION}"
    export INS="yum install -y"
    ${INS} socat wget git sudo ca-certificates && update-ca-trust force-enable
    wget -N -P /etc/yum.repos.d/ https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/nginx.repo
  elif [[ "${ID}" == "ol" ]]; then
    print_ok "当前系统为 Oracle Linux ${VERSION_ID} ${VERSION}"
    export INS="yum install -y"
    ${INS} wget git sudo
    wget -N -P /etc/yum.repos.d/ https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/nginx.repo
  elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 9 ]]; then
    print_ok "当前系统为 Debian ${VERSION_ID} ${VERSION}"
    export XITONG_ID="debian"
    export INS="apt install -y"
    ${INS} socat wget git sudo ca-certificates && update-ca-certificates
    # 清除可能的遗留问题
    rm -f /etc/apt/sources.list.d/nginx.list
    $INS lsb-release gnupg2

    echo "deb http://nginx.org/packages/debian $(lsb_release -cs) nginx" >/etc/apt/sources.list.d/nginx.list
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

    apt update
  elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 18 ]]; then
    print_ok "当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME}"
    export XITONG_ID="ubuntu"
    export INS="apt install -y"
    ${INS} socat wget git sudo ca-certificates && update-ca-certificates
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
  systemctl mask firewalld
  systemctl stop nftables
  systemctl disable nftables
  systemctl stop ufw
  systemctl disable ufw
  if [[ `systemctl status iptables |grep -c "enabled"` == '1' ]]; then
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -F
    echo '
    #! /bin/sh
    ### BEGIN INIT INFO
    # Provides:        acceptoff
    # Required-Start:  $local_fs $remote_fs
    # Required-Stop:   $local_fs $remote_fs
    # Default-Start:   2 3 4 5
    # Default-Stop:
    # Short-Description: automatic crash report generation
    ### END INIT INFO

    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -F
    ' >/etc/init.d/acceptoff
    sed -i 's/^[ ]*//g' /etc/init.d/acceptoff
    sed -i '/^$/d' /etc/init.d/acceptoff
    chmod 755 /etc/init.d/acceptoff
    update-rc.d acceptoff defaults 90
  fi
}

function kaishi_install() {
  echo
  echo
  export YUMING="请输入您的域名"
  ECHOY "${YUMING}[比如：v2.xray.com]"
  while :; do
  domainy=""
  read -p " ${YUMING}：" domain
  if [[ -n "${domain}" ]] && [[ "$(echo ${domain} |grep -c '\.')" -ge '1' ]]; then
    domainy="Y"
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
  ECHOY "请输入端口号"
  ECHOG "建议直接回车使用默认[443]端口,只有443端口才能使用伪装网站"
  export DUANKOU="请输入[1-65535]之间的值"
  while :; do
  read -p " ${DUANKOU}：" PORT
  export PORT=${PORT:-"443"}
  if [[ "$PORT" -ge "1" ]] && [[ "$PORT" -le "65535" ]]; then
    export PORTY="y"
  fi
  case $PORTY in
  y)
    export PORT="${PORT}"
  break
  ;;
  *)
    export DUANKOU="敬告：请输入[1-65535]之间的值"
  ;;
  esac
  done
  echo
  ECHOG "您的域名为：${domain}"
  ECHOG "您设置端口为：${PORT}"
  echo
  read -p " [检查是否正确,正确回车继续,不正确按Q回车重新输入]： " NNKC
  case $NNKC in
  [Qq])
    install_xray_ws
    exit 0
  ;;
  *)
    echo
    print_ok "您已确认无误!"
  ;;
  esac
  export WS_PATH="$(date +VLEws%d%M%S)"
  export VMTCP="$(date +VME%S%d%H)"
  export VMWS="$(date +VMEws%M%S%H)"
  export UUID="$(cat /proc/sys/kernel/random/uuid)"
  export QJPASS="$(cat /proc/sys/kernel/random/uuid)"
  echo
  ECHOY "开始执行安装程序,请耐心等候..."
  sleep 3
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
    wget -P /usr/bin https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/jq && chmod +x /usr/bin/jq
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

function configure_xray_ws() {
  bash -c "$(curl -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/config.sh)"
  judge "修改 Xray 配置文件"
  chmod +x $domain_tmp_dir/config.json
}

function xray_install() {
  print_ok "安装 Xray"
  curl -L https://raw.githubusercontent.com/XTLS/Xray-install/refs/heads/main/install-release.sh | bash -s -- install
  judge "Xray 安装"
}

function configure_nginx() {
  nginx_conf="/etc/nginx/conf.d/${domain}.conf"
  cd /etc/nginx/conf.d/ && rm -f ${domain}.conf && wget -O ${domain}.conf https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/web.conf
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
    echo $domain >$xray_conf_dir/domain
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
    if "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /ssl/xray.crt --keypath /ssl/xray.key --reloadcmd "systemctl restart xray" --ecc --force; then
      print_ok "SSL 证书配置成功"
      "$HOME"/.acme.sh/acme.sh --upgrade --auto-upgrade
      echo $domain >"$HOME"/.acme.sh/domainjilu
      echo $domain >$xray_conf_dir/domain
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

function xrayliugen_conf() {
echo "
#此文件请勿删除，如果要修改，请保持此处变量跟config.json文件一致
export WS_PATH="${WS_PATH}"
export VMTCP="${VMTCP}"
export VMWS="${VMWS}"
export PORT="${PORT}"
export UUID="${UUID}"
export QJPASS="${QJPASS}"
" > $domain_tmp_dir/pzconcon
chmod 775 $domain_tmp_dir/pzconcon
}

function configure_cloudreve() {
  [[ ! -d "${cloudreve_service}" ]] && mkdir -p "${cloudreve_service}"
  [[ ! -d "${cloudreve_path}" ]] && mkdir -p "${cloudreve_path}"
  latest_ver="$(wget -qO- -t1 -T2 "https://api.github.com/repos/cloudreve/Cloudreve/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')"
  cd "${cloudreve_path}"
  echo "${latest_ver}" > latest_ver
  wget -q -P "${cloudreve_path}" https://github.com/cloudreve/Cloudreve/releases/download/${latest_ver}/cloudreve_${latest_ver}_linux_amd64.tar.gz -O "${cloudreve_path}"/cloudreve_${latest_ver}_linux_amd64.tar.gz
  judge "cloudreve下载"
  sleep 1
  tar xzf cloudreve_${latest_ver}_linux_amd64.tar.gz -C "${cloudreve_path}"
  judge "cloudreve解压"
  sleep 1
  rm -fr "${cloudreve_path}"/cloudreve_${latest_ver}_linux_amd64.tar.gz
  chmod +x ./cloudreve
  timeout -k 1s 15s ./cloudreve |tee build.log
  print_ok "cloudreve安装 完成"
  Passwd="$(cat ${cloudreve_path}/build.log | grep "初始管理员密码：" | awk '{print $4}')"
  sleep 2
cat >"${cloudreve_service}"/cloudreve.service <<-EOF
[Unit]
Description=Cloudreve
Documentation=https://docs.cloudreve.org
After=network.target
Wants=network.target
[Service]
WorkingDirectory=${cloudreve_path}
ExecStart=${cloudreve_path}/cloudreve
Restart=on-abnormal
RestartSec=5s
KillMode=mixed
StandardOutput=null
StandardError=syslog
[Install]
WantedBy=multi-user.target
EOF
nginx_conf="/etc/nginx/conf.d/${domain}.conf"
cat >"$nginx_conf" <<-EOF
server {
    listen  80;
    server_name  ${domain};
    location / { 
        root   /usr/share/nginx/html;
        index  index.html index.htm;
           proxy_pass http://127.0.0.1:5212;
    }
}
EOF
  cd "$HOME"
  chmod 775 "${cloudreve_service}"/cloudreve.service
  systemctl daemon-reload
  systemctl start cloudreve
  systemctl enable cloudreve
}

function configure_pzcon() {
  bash -c "$(curl -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/pzcon.sh)"
  judge "节点链接信息"
  sleep 2
  echo
  echo
  chmod 775 $domain_tmp_dir/pzcon && source $domain_tmp_dir/pzcon
}

function restart_all() {
  ECHOY "正在重启应用中，请稍后..."
  xrayliugen_conf
  systemctl restart nginx
  systemctl restart cloudreve
  systemctl restart xray
  curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray_install.sh > /sbin/glxray
  chmod 777 /sbin/glxray
  sleep 3
  clear
  echo
  echo
  if [[ `systemctl status nginx |grep -c "active (running) "` == '1' ]]; then
    print_ok "nginx运行 正常"
  else
    print_error "nginx没有运行"
    exit 1
  fi
  if [[ `systemctl status cloudreve |grep -c "active (running) "` == '1' ]]; then
    print_ok "cloudreve运行 正常"
  else
    print_error "cloudreve没有运行"
  fi
  if [[ `systemctl status xray |grep -c "active (running) "` == '1' ]]; then
    print_ok "xray运行 正常"
  else
    print_error "xray没有运行"
    exit 1
  fi
}

function cloudreve_xinxi() {
  curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray_install.sh > /sbin/glxray
  chmod 777 /sbin/glxray
  echo -e "\033[41;33m 请注意：以下[cloudreve云盘]操作必须处理  \033[0m"
  echo
  ECHOY "1、用浏览器打开此链接： https://${domain}"
  ECHOY "2、初始管理员账号：admin@cloudreve.org"
  ECHOY "3、${Passwd}"
  ECHOY "4、点击右上角头像 -> 管理面板"
  ECHOY "5、点击[管理面板]会弹出对话框 \"确定站点URL设置\" 必须选择 \"更改\""
  ECHOY "6、左侧 -> 参数设置 -> 注册与登陆 -> 不允许新用户注册 -> 往下拉点击保存"
  ECHOY "7、左侧 -> 用户 -> 新建用户 -> 添加一个新的管理员，用于自己登录所用"
  echo
  ECHOG "友情提示：再次输入安装命令或者输入[glxray]命令可以对程序进行管理"
  echo
  echo
}


#修改配置
function configure_gaipeizhi() {
  [[ ! "${saocaozhuo}" == "1" ]] && clear
  echo
  chmod +x $domain_tmp_dir/pzconcon && source $domain_tmp_dir/pzconcon
  [[ -f "${xray_conf_dir}/domain" ]] && export domain=$(cat ${xray_conf_dir}/domain)
  [[ -z "${domain}" ]] && export domain="$(cat $HOME/.acme.sh/domainjilu)"
  echo -e "${Green} 1.${Font}  修改Xray节点UUID"
  echo -e "${Green} 2.${Font}  修改Xray节点端口"
  echo -e "${Green} 3.${Font}  修改Xray-ws节点路径"
  echo -e "${Green} 4.${Font}  修改Trojan密码"
  echo -e "${Green} 5.${Font}  返回主菜单"
  echo -e "${Green} 6.${Font}  打印出 Xray 节点信息" 
  echo -e "${Green} 7.${Font}  退出"
  echo
  XUANZHEXG="请输入数字"
  while :; do
  read -p " ${XUANZHEXG}：" menu_xrayxg
  case $menu_xrayxg in
  1)
    ECHOG "修改Xray节点UUID"
    XUUID="${UUID}"
    ECHOY "直接回车,默认为继续使用旧的UUID：${XUUID}"
    read -p " 请输入新的UUID：" UUID
    export UUID=${UUID:-"$XUUID"}
    ECHOG "您新的UUID为：${UUID}"
    export Gengxinpeizhi="UUID"
    configure_gengxinxinxi
    break
    ;;
  2)
    ECHOG "修改Xray节点端口"
    XPORT="${PORT}"
    ECHOY "直接回车,默认为继续使用旧的端口：${XPORT}"
    read -p " 请输入新的端口：" PORT
    export PORT=${PORT:-"$XPORT"}
    ECHOG "您新的端口为：${PORT}"
    export Gengxinpeizhi="端口"
    configure_gengxinxinxi
    break
    ;;
  3)
    ECHOG "修改Xray-ws节点路径"
    XWS_PATH="${WS_PATH}"
    ECHOY "直接回车,默认为继续使用旧的节点路径：/${XWS_PATH}/"
    ECHOY "修改路径只需要修改/ /之间内容即可,记住不需要前后增加 / "
    read -p " 请输入新的端口：" WS_PATH
    export WS_PATH=${WS_PATH:-"$XWS_PATH"}
    ECHOG "您新的路径为：/${WS_PATH}/"
    export Gengxinpeizhi="Xray-ws节点路径"
    configure_gengxinxinxi
    break
    ;;
  4)
    ECHOG "修改Trojan密码"
    XQJPASS="${QJPASS}"
    ECHOY "直接回车,默认为继续使用旧的密码：${XQJPASS}"
    read -p " 请输入新的密码：" QJPASS
    export QJPASS=${QJPASS:-"XQJPASS"}
    ECHOG "您Trojan新的密码为：${QJPASS}"
    export Gengxinpeizhi="Trojan密码"
    configure_gengxinxinxi
    break
    ;;
  5)
    menu
    break
    ;;
  6)
    clear
    echo
    echo
    source $domain_tmp_dir/pzcon
    break
    ;;
  7)
    exit 0
    break
    ;;
    *)
    XUANZHEXG="请输入正确的选择"
    ;;
  esac
  done
}

function configure_gengxinxinxi() {
  echo
  bash -c "$(curl -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/config.sh)"
  judge "生成新配置"
  bash -c "$(curl -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/pzcon.sh)"
  judge "更新节点信息"
  print_ok "修改${Gengxinpeizhi} 完成"
  restart_all
  saocaozhuo="1"
  print_Hi "请继续您的骚操作!"
  configure_gaipeizhi
}

function xray_uninstall() {
  bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
  find / -iname 'xray' | xargs -i rm -rf {}
  print_ok "Xray御载 完成"
  sleep 2
  systemctl stop cloudreve
  systemctl disable cloudreve
  systemctl daemon-reload
  find / -iname 'cloudreve' | xargs -i rm -rf {}
  print_ok "cloudreve御载 完成"
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
  if [[ -e "$HOME"/.acme.sh ]]; then
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

function install_xray_ws() {
  is_root
  kaishi_install
  system_check
  dependency_install
  basic_optimization
  domain_check
  port_exist_check 80
  xray_install
  configure_xray_ws
  nginx_install
  configure_nginx
  generate_certificate
  ssl_judge_and_install
  configure_cloudreve
  restart_all
  configure_pzcon
  cloudreve_xinxi
}
menu() {
  clear
  echo
  echo
  running_state
  echo -e "${XRAY_ZT}"
  echo -e "${NGINX_ZT}"
  echo -e "${CLOUDREVE_ZT}"
  echo
  ECHOY "1、安装 Xray、nginx和cloudreve"
  ECHOY "2、打印 Xray 节点信息"
  ECHOY "3、安装 BBR、锐速加速"
  ECHOY "4、更新 Xray"
  ECHOY "5、修改 UUID/端口/路径/Tronjian密码"
  ECHOY "6、删除 阿里云盾或腾讯云盾"
  ECHOY "7、卸载 Xray、nginx和cloudreve"
  ECHOY "8、重启 Xray、nginx和cloudreve"
  ECHOY "9、退出"
  echo
  echo
  XUANZHE="请输入数字"
  while :; do
  read -p " ${XUANZHE}：" menu_num
  case $menu_num in
  1)
    install_xray_ws
    break
    ;;
  2)
    source $domain_tmp_dir/pzcon
    break
    ;;
  3)
    wget -N --no-check-certificate "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
    break
    ;;
  4)
    systemctl stop xray
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" - install
    restart_all
    break
    ;;
  5)
    configure_gaipeizhi
    break
    ;;
    
  6)
    bash -c "$(curl -Ls https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray/uninstall_firewall.sh)"
    break
    ;;
  7)
    xray_uninstall
    break
    ;;
  8)
    restart_all
    break
    ;;
  9)
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
