
#!/bin/bash

#====================================================
# Author：dahuilang
# Dscription：MTProto proxy onekey Management
# github：https://github.com/shidahuilang
#====================================================
RED="\033[0;31m"
GR="\033[0;32m"
YE="\033[0;33m"
NC="\033[0m"
BL="\033[36m"
Font="\033[0m"

WORKDIR=`pwd`
SRC_DIR=mtproto_proxy
SELF="$0"

info() {
    echo -e "${GR}INFO${NC}: $1"
}

warn() {
    echo -e "${YE}WARNING${NC}: $1"
}

error() {
    echo -e "${RED}ERROR${NC}: $1" 1>&2
    exit 1
}

usage() {
    echo "MTProto proxy installer.
Install proxy:
${SELF} -p <port> -s <secret> -t <ad tag> -a dd -a tls -d <fake-tls domain>
Upgrade code to the latest version and restart, keeping config unchanged:
${SELF} upgrade
Interactively generate new config and reload proxy settings:
${SELF} reconfigure -p <port> -s <secret> -t <ad tag> -a dd -a tls -d <fake-tls domain>
Reload proxy settings after manual changes in config/prod-sys.cnfig:
${SELF} reload
"
}

to_hex() {
    od -A n -t x1 -w128 | sed 's/ //g'
}


case "$1" in
    reconfigure|reload|upgrade|install)
        CMD="$1"
        shift
        ;;
    *)
        CMD="install"
esac

PORT=${MTP_PORT:-""}
SECRET=${MTP_SECRET:-""}
TAG=${MTP_TAG:-""}
DD_ONLY=${MTP_DD_ONLY:-""}
TLS_ONLY=${MTP_TLS_ONLY:-""}
TLS_DOMAIN=${MTP_TLS_DOMAIN:-""}

# check command line options
while getopts "p:s:t:a:d:h" o; do
    case "${o}" in
        p)
            PORT=${OPTARG}
            ;;
        s)
            SECRET=${OPTARG}
            ;;
        t)
            TAG=${OPTARG}
            ;;
        a)
            case "${OPTARG}" in
                "dd")
                    DD_ONLY="y"
                    ;;
                "tls")
                    TLS_ONLY="y"
                    ;;
                *)
                    error "Invalid -a value: '${OPTARG}'"
            esac
            ;;
        d)
            TLS_DOMAIN=${OPTARG}
            ;;
        h)
            usage
            exit 0
    esac
done


echo "Interactive MTProto proxy installer."
echo "You can make the process fully automated by calling this script as 'echo \"y\ny\ny\ny\ny\ny\" | $0'."
echo "Try $0 -h for more options."

set -e

source /etc/os-release
info "Detected OS is ${ID} ${VERSION_ID}"

do_running_state() {
    if [[ ! -d /opt/mtp_proxy/releases/0.1.0 ]] && [[ ! -d /var/log/mtproto-proxy ]]; then
        export MTPROTO_ZT="${BL} mtproto-proxy状态${Font}：${RED}未安装${Font}"
    elif [[ -d /opt/mtp_proxy/releases/0.1.0 ]] && [[ `systemctl status mtproto-proxy |grep -c "active (running) "` == '1' ]]; then
        export MTPROTO_ZT="${BL} mtproto-proxy状态${Font}：${GR}运行中 ${Font}"
    elif [[ -d /opt/mtp_proxy/releases/0.1.0 ]] && [[ -d /var/log/mtproto-proxy ]] && [[ `systemctl status mtproto-proxy |grep -c "active (running) "` == '0' ]]; then
        export MTPROTO_ZT="${BL} mtproto-proxy状态${Font}：${GR}已安装${Font},${RED}未运行${Font}"
    else
        export MTPROTO_ZT="${BL} mtproto-proxy状态：${Font}未知"
    fi
}

do_kaishi_install() {
    sed -i '/^\*\ *soft\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    sed -i '/^\*\ *hard\ *nofile\ *[[:digit:]]*/d' /etc/security/limits.conf
    echo '* soft nofile 65536' >>/etc/security/limits.conf
    echo '* hard nofile 65536' >>/etc/security/limits.conf
    echo
    echo -e "\033[33m 请输入端口号 \033[0m"
    echo -e "\033[32m 如果此服务器没其他占用443端口的，建议直接回车使用默认[443]端口 \033[0m"
    export DUANKOU="请输入[1-65535]之间的值"
    while :; do
    read -p " ${DUANKOU}：" PORT
    export PORT=${PORT:-"443"}
    if [[ $PORT -ge 1 ]] && [[ $PORT -le 65535 ]]; then
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
    echo -e "\033[32m 您设置端口为：${PORT} \033[0m"
    echo
    echo -e "\033[33m 正在为您安装TG代理，请稍后... \033[0m"
    sys_pro="/etc/systemd/system"
    if [[ `systemctl status mtproto-proxy |grep -c "active (running) "` == '1' ]]; then
        Uninstall_mtproto_proxy
    fi
    [[ ! -d ${sys_pro} ]] && mkdir -p ${sys_pro}
    do_systemd_system
}

do_configure_os() {
    # We need at least 'make' 'sed' 'diff' 'od' 'install' 'tar' 'base64' 'awk'
    source '/etc/os-release'
    if [[ ${ID} == centos ]] && [[ ${VERSION} == 8 ]]; then
       ID="centos8"
    fi
    case "${ID}" in
        ubuntu)
            info "Installing required APT packages"
            sudo apt-get -y update
            sudo apt-get -y install wget dbus make sed diffutils tar systemd ca-certificates git socat
            sudo update-ca-certificates
            if [[ `timeout -k 1s 3s erl |grep -c "Eshell V"` == '0' ]]; then
                wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
                sudo dpkg -i erlang-solutions_2.0_all.deb
                sudo apt-get -y update
                sudo apt-get -y install erlang
            fi
            ;;
        debian)
            info "Installing extra repositories"
            sudo apt -y update
            sudo apt-get -y install wget dbus make sed diffutils tar systemd ca-certificates git socat
            sudo update-ca-certificates
            if [[ `timeout -k 1s 3s erl |grep -c "Eshell V"` == '0' ]]; then
                wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
                sudo dpkg -i erlang-solutions_2.0_all.deb
                sudo apt -y update
                sudo apt-get -y install erlang
            fi
            ;;
        centos)
            info "Installing extra repositories"
            sudo yum -y install wget make sed diffutils tar systemd dbus git socat ca-certificates
            sudo update-ca-trust force-enable
            if [[ `timeout -k 1s 3s erl |grep -c "Eshell V"` == '0' ]]; then
                wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
                rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
                sudo yum -y install erlang
            fi
            yum update -y
            ;;
        centos8)
            info "Installing extra repositories"
            sudo yum -y install wget make sed diffutils tar systemd dbus git socat ca-certificates
            sudo update-ca-trust force-enable
            if [[ `timeout -k 1s 3s erl |grep -c "Eshell V"` == '0' ]]; then
                curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
                sudo yum -y clean all
                sudo yum -y makecache
                sudo yum -y install erlang
            fi
            yum update -y
            ;;
        *)
            echo -e "\033[31m 不支持您的系统进行安装 \033[0m"
            exit 1
    esac

    info "Making sure clock synchronization is enabled"
    if [ `systemctl is-active ntp` = "active" ]; then
        info "Replacing ntpd with systemd-timesyncd"
        systemctl disable ntp
        systemctl stop ntp
    fi
    sudo timedatectl set-ntp on
    info "Current time: `date`"
}

do_systemd_system() {
sys_proxy="/etc/systemd/system/mtproto-proxy.service"
cat >$sys_proxy <<-EOF
[Unit]
SourcePath=/opt/mtp_proxy/bin/mtp_proxy
Description=Starts the mtproto_proxy server
After=local-fs.target
After=remote-fs.target
After=network-online.target
After=systemd-journald-dev-log.socket
After=nss-lookup.target
Wants=network-online.target
Requires=epmd.service
[Service]
Type=simple
User=mtproto-proxy
Group=mtproto-proxy
Environment="RUNNER_LOG_DIR=/var/log/mtproto-proxy"
Restart=on-failure
TimeoutSec=1min
IgnoreSIGPIPE=no
KillMode=process
GuessMainPID=no
RemainAfterExit=no
LimitNOFILE=40960
AmbientCapabilities=CAP_NET_BIND_SERVICE
ExecStart=/opt/mtp_proxy/bin/mtp_proxy foreground
ExecStop=/opt/mtp_proxy/bin/mtp_proxy stop
ExecReload=/opt/mtp_proxy/bin/mtp_proxy rpcterms mtproto_proxy_app reload_config
TimeoutStopSec=15s
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
}

do_get_source() {
    info "Downloading proxy source code"
    curl -L https://github.com/seriyps/mtproto_proxy/archive/master.tar.gz -o mtproto_proxy.tar.gz

    info "Unpacking source code"
    tar -xaf mtproto_proxy.tar.gz

    mv -T --backup=t mtproto_proxy-master $SRC_DIR
}

# cd mtproto_proxy/

do_build_config() {
    info "Interactively generating config-file"

    # So, we ask for port/secret/ad_tag/protocols only if they are not specified via
    # command-line or env vars

    PORT="${PORT}"

    if [ "${ID}" = "centos" -a "`sudo firewall-cmd --state 2>&1`" = "running" ]; then
        info "Opening ${PORT} port"
        sudo firewall-cmd --zone=public --add-port=${PORT}/tcp --permanent
        sudo firewall-cmd --reload
    else
        warn "Please make sure proxy port ${PORT} is open on firewall!
        Use smth like:
        firewall-cmd --zone=public --add-port=${PORT}/tcp --permanent
        firewall-cmd --reload"
    fi

    if [ -z "${SECRET}" ]; then
        export SECRET=`head -c 16 /dev/urandom | to_hex`
        info "Using random secret ${SECRET}"
    fi

    if [ -z "${TAG}" ]; then
        export TAG="$(date +8b%d1%M5ec12abd%S6faeb2f%Mefbdcb)"
        info "Using no AD TAG"
    fi

    if [ -z "${DD_ONLY}" ]; then
        export DD_ONLY="y"
        info "Using dd-only mode"
    fi

    if [ -z "${TLS_ONLY}" ]; then
        export TLS_ONLY="y"
        info "Using TLS-only mode"
    fi

    if [ -z "${TLS_DOMAIN}" -a \( -n "${TLS_ONLY}" -o -z "${DD_ONLY}" \) ]; then
        # If tls_domain is not set and fake-tls is enabled, ask for domain
        export TLS_DOMAIN="s3.amazonaws.com"
        info "Using '${TLS_DOMAIN}' for fake-TLS SNI"
    fi

    PROTO_ARG=""
    if [ -n "${DD_ONLY}" -a -n "${TLS_ONLY}" ]; then
        export PROTO_ARG='{allowed_protocols, [mtp_fake_tls,mtp_secure]},'
    elif [ -n "${DD_ONLY}" ]; then
        export PROTO_ARG='{allowed_protocols, [mtp_secure]},'
    elif [ -n "${TLS_ONLY}" ]; then
        export PROTO_ARG='{allowed_protocols, [mtp_fake_tls]},'
    fi

    [ -z "${PORT}" -o -z "${SECRET}" -o -z "${TAG}" ] && \
        error "Not enough options: port='${PORT}' secret='${SECRET}' ad_tag='${TAG}'"

    [ ${PORT} -gt 0 -a ${PORT} -lt 65535 ] || \
        error "Invalid port value: ${PORT}"

    [ -n "`echo $SECRET | grep -x '[[:xdigit:]]\{32\}'`" ] || \
        error "Invalid secret. Should be 32 chars of 0-9 a-f"

    [ -n "`echo $TAG | grep -x '[[:xdigit:]]\{32\}'`" ] || \
        error "Invalid tag. Should be 32 chars of 0-9 a-f"

    [ -z "${TLS_DOMAIN}" -o -n "`echo $TLS_DOMAIN | grep -xE '^([0-9a-z_-]+\.)+[a-z]{2,6}$'`" ] || \
        error "Invalid TLS domain '${TLS_DOMAIN}'. Should be valid domain name!"

    echo '
%% -*- mode: erlang -*-
[
 {mtproto_proxy,
  %% see src/mtproto_proxy.app.src for examples.
  [
   '${PROTO_ARG}'
   {ports,
    [#{name => mtp_handler_1,
       listen_ip => "0.0.0.0",
       port => '${PORT}',
       secret => <<"'${SECRET}'">>,
       tag => <<"'${TAG}'">>}
    ]}
   ]},
 %% Logging config
 {lager,
  [{log_root, "/var/log/mtproto-proxy"},
   {crash_log, "crash.log"},
   {handlers,
    [
     {lager_console_backend,
      [{level, critical}]},
     {lager_file_backend,
      [{file, "application.log"},
       {level, info},
       %% Do fsync only on critical messages
       {sync_on, critical},
       %% If we logged more than X messages in a second, flush the rest
       {high_water_mark, 300},
       %% If we hit hwm and msg queue len is >X, flush the queue
       {flush_queue, true},
       {flush_threshold, 2000},
       %% How often to check if log should be rotated
       {check_interval, 5000},
       %% Rotate when file size is 100MB+
       {size, 104857600}
      ]}
    ]}]},
 {sasl, [{errlog_type, error}]}
].' >config/prod-sys.config


    info "Config is generated with following properties:
port=${PORT} secret=${SECRET} tag=${TAG} tls_only=${TLS_ONLY} dd_only=${DD_ONLY} domain=${TLS_DOMAIN}"
}

do_backup_config() {
    cp $SRC_DIR/config/prod-sys.config $WORKDIR/prod-sys.config.bak
}

do_restore_config() {
    cp $WORKDIR/prod-sys.config.bak config/prod-sys.config
}

do_reload_config() {
    sudo make update-sysconfig
    sudo systemctl reload mtproto-proxy
}

do_build() {
    info "Generating Erlang interpreter options"
    make config/prod-vm.args

    info "Compiling"
    make
}

do_install() {
    # Try to stop proxy in case this script is run not for the first time
    sudo systemctl stop mtproto-proxy || true

    info "Installing"
    sudo make install

    info "Starting"
    sudo systemctl enable mtproto-proxy
    sudo systemctl start mtproto-proxy
}

do_print_links() {
    info "Detecting IP address"
    IP=`curl -s -4 -m 10 http://ipv4.seriyps.ru || curl -s -4 -m 10 https://digitalresistance.dog/myIp`
    info "Detected external IP is ${IP}"

    URL_PREFIX="https://t.me/proxy?server=${IP}&port=${PORT}&secret="

    ESCAPED_SECRET=$(echo -n $SECRET | sed 's/../\\x&/g') # bytes
    ESCAPED_TLS_SECRET="\xee${ESCAPED_SECRET}"${TLS_DOMAIN}
    BASE64_TLS_SECRET=`echo -ne $ESCAPED_TLS_SECRET | base64 -w 0 | tr '+/' '-_'`
    HEX_TLS_SECRET=`echo -ne $ESCAPED_TLS_SECRET | to_hex`

    info "Logs: /var/log/mtproto-proxy/application.log"
    info "Secret: ${SECRET}"
    info "Proxy links:
${YE}Normal链接:${Font}${URL_PREFIX}${SECRET}
${YE}Secure链接:${Font}${URL_PREFIX}dd${SECRET}
${YE}Fake-TLS hex链接:${Font}${URL_PREFIX}${HEX_TLS_SECRET}
${YE}Fake-TLS base64链接:${Font}${URL_PREFIX}${BASE64_TLS_SECRET}
"
    rm -fr $WORKDIR/mtproto_proxy.tar.gz
    
cat >$WORKDIR/mtproto_proxy/conck <<-EOF
echo -e "\033[33mNormal链接:\033[0m${URL_PREFIX}${SECRET}"
echo -e "\033[33mSecure链接:\033[0m${URL_PREFIX}dd${SECRET}"
echo -e "\033[33mFake-TLS hex链接:\033[0m${URL_PREFIX}${HEX_TLS_SECRET}"
echo -e "\033[33mFake-TLS base64链接:\033[0m${URL_PREFIX}${BASE64_TLS_SECRET}"
EOF
}

# info "Executing $CMD"

install_mtproto_proxy() {
    do_kaishi_install
    do_configure_os
    do_get_source
    cd $SRC_DIR/
    do_build_config
    do_build
    do_install
    do_print_links
    info "MTProto proxy 安装完毕!"
}

Uninstall_mtproto_proxy() {
    sudo systemctl stop mtproto-proxy
    sudo systemctl disable mtproto-proxy
    find / -iname 'mtproto_proxy' | xargs -i rm -rf {} > /dev/null 2>&1
    find / -iname 'mtproto-proxy' | xargs -i rm -rf {} > /dev/null 2>&1
    find / -iname 'mtp_proxy' | xargs -i rm -rf {} > /dev/null 2>&1
    rm -rf /etc/systemd/system/mtproto-proxy.service > /dev/null 2>&1
}

mtpro() {
    clear
    echo
    echo
    do_running_state
    echo -e "${MTPROTO_ZT}"
    echo 
    echo -e "\033[33m 1、安装 TG代理 \033[0m"
    echo -e "\033[33m 2、打印 TG代理链接 \033[0m"
    echo -e "\033[33m 3、御载 TG代理 \033[0m"
    echo -e "\033[33m 4、退出 \033[0m"
    echo
    XUANZHE_mtpr="请输入数字"
    while :; do
    read -p " ${XUANZHE_mtpr}：" menu_mtpro
    case $menu_mtpro in
        1)
          install_mtproto_proxy
          break
        ;;
        2)
          source $WORKDIR/mtproto_proxy/conck
          break
        ;;
        3)
          echo
          echo -e "\033[32m 正在御载TG代理，请稍后... \033[0m"
          Uninstall_mtproto_proxy
          break
        ;;
        4)
          exit 0
          break
        ;;
        *)
          XUANZHE_mtpr="请输入正确的选择"
        ;;
    esac
    done
}
mtpro "$@"
