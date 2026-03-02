#!/bin/bash
# shadowsocks/ss Ubuntu一键安装脚本 (修复版)
# 修复: 移除失效代理, 改用apt安装, 兼容Ubuntu 20.04/22.04/24.04

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[36m"
PLAIN='\033[0m'

IP=`curl -sL -4 ip.sb`
if [[ "$?" != "0" ]]; then
    IP=`curl -sL -6 ip.sb`
fi

CONFIG_FILE="/etc/shadowsocks-libev/config.json"

colorEcho() {
    echo -e "${1}${@:2}${PLAIN}"
}

checkSystem() {
    result=$(id | awk '{print $1}')
    if [ $result != "uid=0(root)" ]; then
        colorEcho $RED " 请以root身份执行该脚本"
        exit 1
    fi

    res=`which apt`
    if [ "$?" != "0" ]; then
        colorEcho $RED " 系统不是Ubuntu/Debian"
        exit 1
    fi
}

slogon() {
    clear
    echo "#############################################################"
    echo -e "#         ${RED}Ubuntu Shadowsocks/SS 一键安装脚本 (修复版)${PLAIN}       #"
    echo "#############################################################"
    echo ""
}

getData() {
    read -p " 请设置SS的密码（不输入则随机生成）:" PASSWORD
    [ -z "$PASSWORD" ] && PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`
    echo ""
    colorEcho $BLUE " 密码： $PASSWORD"
    echo ""

    while true
    do
        read -p " 请设置SS的端口号[1025-65535]:" PORT
        [ -z "$PORT" ] && PORT="12345"
        if [ "${PORT:0:1}" = "0" ]; then
            echo -e "${RED}端口不能以0开头${PLAIN}"
            exit 1
        fi
        expr $PORT + 0 &>/dev/null
        if [ $? -eq 0 ]; then
            if [ $PORT -ge 1025 ] && [ $PORT -le 65535 ]; then
                echo ""
                colorEcho $BLUE " 端口号： $PORT"
                echo ""
                break
            else
                colorEcho $RED " 输入错误，端口号为1025-65535的数字"
            fi
        else
            colorEcho $RED " 输入错误，端口号为1025-65535的数字"
        fi
    done
    colorEcho $BLUE " 请选择SS的加密方式:"
    echo "   1)aes-256-gcm"
    echo "   2)aes-192-gcm"
    echo "   3)aes-128-gcm"
    echo "   4)aes-256-ctr"
    echo "   5)aes-192-ctr"
    echo "   6)aes-128-ctr"
    echo "   7)aes-256-cfb"
    echo "   8)aes-192-cfb"
    echo "   9)aes-128-cfb"
    echo "   10)camellia-128-cfb"
    echo "   11)camellia-192-cfb"
    echo "   12)camellia-256-cfb"
    echo "   13)chacha20-ietf"
    echo "   14)chacha20-ietf-poly1305"
    echo "   15)xchacha20-ietf-poly1305"
    read -p " 请选择加密方式（默认aes-256-gcm）" answer
    if [ -z "$answer" ]; then
        METHOD="aes-256-gcm"
    else
        case $answer in
        1)  METHOD="aes-256-gcm" ;;
        2)  METHOD="aes-192-gcm" ;;
        3)  METHOD="aes-128-gcm" ;;
        4)  METHOD="aes-256-ctr" ;;
        5)  METHOD="aes-192-ctr" ;;
        6)  METHOD="aes-128-ctr" ;;
        7)  METHOD="aes-256-cfb" ;;
        8)  METHOD="aes-192-cfb" ;;
        9)  METHOD="aes-128-cfb" ;;
        10) METHOD="camellia-128-cfb" ;;
        11) METHOD="camellia-192-cfb" ;;
        12) METHOD="camellia-256-cfb" ;;
        13) METHOD="chacha20-ietf" ;;
        14) METHOD="chacha20-ietf-poly1305" ;;
        15) METHOD="xchacha20-ietf-poly1305" ;;
        *)
            colorEcho $RED " 无效的选择，使用默认的aes-256-gcm"
            METHOD="aes-256-gcm"
        esac
    fi
    echo ""
    colorEcho $BLUE " 加密方式： $METHOD"
    echo ""
}

preinstall() {
    colorEcho $BLUE " 更新系统..."
    apt clean all
    apt update

    colorEcho $BLUE " 安装必要软件"
    apt install -y wget vim net-tools unzip tar qrencode
    apt autoremove -y
}

installSS() {
    colorEcho $BLUE " 安装SS..."

    # 直接使用apt安装shadowsocks-libev（最稳定可靠的方式）
    apt install -y shadowsocks-libev

    if [[ $? -ne 0 ]]; then
        colorEcho $YELLOW " apt安装失败，尝试添加PPA源..."
        apt install -y software-properties-common
        add-apt-repository -y ppa:max-c-lv/shadowsocks-libev 2>/dev/null
        apt update
        apt install -y shadowsocks-libev
        if [[ $? -ne 0 ]]; then
            colorEcho $RED " Shadowsocks-libev 安装失败！"
            exit 1
        fi
    fi

    colorEcho $GREEN " Shadowsocks-libev 安装成功"

    # 写入配置文件
    interface="0.0.0.0"
    mkdir -p /etc/shadowsocks-libev
    cat > $CONFIG_FILE<<-EOF
{
    "server":"$interface",
    "server_port":${PORT},
    "local_port":1080,
    "password":"${PASSWORD}",
    "timeout":600,
    "method":"${METHOD}",
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
    "fast_open":false
}
EOF

    # 创建/覆盖 systemd 服务文件
    cat > /lib/systemd/system/shadowsocks-libev.service <<-EOF
[Unit]
Description=shadowsocks-libev
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
PIDFile=/var/run/shadowsocks-libev.pid
LimitNOFILE=32768
ExecStart=/usr/bin/ss-server -c $CONFIG_FILE
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s TERM \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable shadowsocks-libev
    systemctl restart shadowsocks-libev
    sleep 3
    res=`ss -nltp | grep ${PORT}`
    if [ "${res}" = "" ]; then
        colorEcho $RED " ss启动失败，请检查端口是否被占用！"
        exit 1
    fi
}

setFirewall() {
    res=`ufw status | grep -i inactive`
    if [ "$res" = "" ];then
        ufw allow ${PORT}/tcp
        ufw allow ${PORT}/udp
    fi
}

installBBR() {
    result=$(lsmod | grep bbr)
    if [ "$result" != "" ]; then
        colorEcho $BLUE " BBR模块已安装"
        INSTALL_BBR=false
        return;
    fi

    res=`hostnamectl | grep -i openvz`
    if [ "$res" != "" ]; then
        colorEcho $YELLOW " openvz机器，跳过安装"
        INSTALL_BBR=false
        return
    fi

    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    result=$(lsmod | grep bbr)
    if [[ "$result" != "" ]]; then
        colorEcho $GREEN " BBR模块已启用"
        INSTALL_BBR=false
        return
    fi

    colorEcho $BLUE " 安装BBR模块..."
    INSTALL_BBR=true
}

info() {
    port=`grep server_port $CONFIG_FILE| cut -d: -f2 | tr -d \",' '`
    res=`ss -nltp | grep ${port}`
    [ -z "$res" ] && status="${RED}已停止${PLAIN}" || status="${GREEN}正在运行${PLAIN}"
    password=`grep password $CONFIG_FILE| cut -d: -f2 | tr -d \",' '`
    method=`grep method $CONFIG_FILE| cut -d: -f2 | tr -d \",' '`

    res=`echo -n ${method}:${password}@${IP}:${port} | base64 -w 0`
    link="ss://${res}"

    echo ============================================
    echo -e " ${BLUE}ss运行状态：${PLAIN}${status}"
    echo -e " ${BLUE}ss配置文件：${PLAIN}${RED}$CONFIG_FILE${PLAIN}"
    echo ""
    echo -e " ${RED}ss配置信息：${PLAIN}"
    echo -e "   ${BLUE}IP(address): ${PLAIN} ${RED}${IP}${PLAIN}"
    echo -e "   ${BLUE}端口(port)：${PLAIN}${RED}${port}${PLAIN}"
    echo -e "   ${BLUE}密码(password)：${PLAIN}${RED}${password}${PLAIN}"
    echo -e "   ${BLUE}加密方式(method)：${PLAIN} ${RED}${method}${PLAIN}"
    echo
    echo -e " ${BLUE}ss链接：${PLAIN} ${link}"
    qrencode -o - -t utf8 ${link}
}

bbrReboot() {
    if [ "${INSTALL_BBR}" == "true" ]; then
        echo
        colorEcho $BLUE " 为使BBR模块生效，系统将在30秒后重启"
        echo
        echo -e " 您可以按 ctrl + c 取消重启，稍后输入 ${RED}reboot${PLAIN} 重启系统"
        sleep 30
        reboot
    fi
}

install() {
    echo -n " 系统版本:  "
    cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2

    checkSystem
    getData
    preinstall
    installSS
    setFirewall
    installBBR

    info
    bbrReboot
}

uninstall() {
    read -p " 确定卸载SS吗？(y/n)" answer
    [ -z ${answer} ] && answer="n"

    if [ "${answer}" == "y" ] || [ "${answer}" == "Y" ]; then
        systemctl stop shadowsocks-libev && systemctl disable shadowsocks-libev
        apt remove -y shadowsocks-libev
        rm -rf /etc/shadowsocks-libev
        colorEcho $GREEN " SS卸载完成"
    fi
}

slogon

action=$1
[ -z $1 ] && action=install
case "$action" in
    install|uninstall|info)
        ${action}
        ;;
    *)
        echo " 参数错误"
        echo " 用法: `basename $0` [install|uninstall|info]"
        ;;
esac
