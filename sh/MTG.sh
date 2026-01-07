#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

red() { echo -e "$(tput setaf 1)$*$(tput setaf 9)"; }
green() { echo -e "$(tput setaf 2)$*$(tput setaf 9)"; }
yellow() { echo -e "$(tput setaf 3)$*$(tput setaf 9)"; }

if [[ ! -d /run/systemd/system ]]; then
    red "> 抱歉,此脚本仅支持使用 systemd 的 Linux 发行版,例如: Ubuntu 16.04+/CentOS 7+ ..."
    exit 1
fi

BINEXEC=/usr/local/bin/mtg

CalUnixTsDrifft() {
  local cfts=$(wget -qO- https://www.cloudflare.com/cdn-cgi/trace | grep ts= | cut -d'=' -f2 | cut -d'.' -f1)
  local localts=$(date +"%s")
  local drifft=$(($localts-$cfts))
  # abs value
  echo ${drifft#-}
}


GetBinTag() {
    if [[ $(uname -s) != "Linux" ]]; then
        red "不支持的操作系统: $(uname -s)"
        exit 1
    fi
    case $(uname -m) in 
        x86_64)
            echo "linux-amd64"
            ;;
        i*86)
            echo "linux-386"
            ;;
        aarch64)
            echo "linux-arm64"
            ;;
        arm*)
            echo "linux-arm"
            ;;
        *)
            red "不支持的系统架构: $OSARCH"
            exit 1
            ;;
    esac
}

DEFINPUT () {
    local DEFAULT=$1
    local INPUT
    read INPUT
    if [[ -z $INPUT ]]; then
        echo "$DEFAULT"
    else
        echo "$INPUT"
    fi
}

DLMTG() {
    DLTEMP=$(mktemp --suffix=.tar.gz)
    EXTMPDIR=$(mktemp -d)
    trap 'echo Signal caught, cleaning up >&2; cd /; /bin/rm -rf "$DLTEMP" "EXTMPDIR"; exit 15' 1 2 3 15

    yellow "> 正在下载 MTG 二进制文件..."
    wget -qO- https://api.github.com/repos/9seconds/mtg/releases/latest \
    | grep browser_download_url | grep $(GetBinTag) | cut -d '"' -f 4 \
    | wget -q -i- -O $DLTEMP

    if [[ ! -f $DLTEMP ]]; then
        red "> 下载失败..."
        exit 1
    fi

    yellow "> 正在解压..."
    tar xvf $DLTEMP --strip-components=1 -C $EXTMPDIR

    systemctl stop mtg || true
    yellow "> 正在安装 MTG 二进制文件..."
    install -v -m755 $EXTMPDIR/mtg $BINEXEC
    yellow "> 清理临时文件..."
    rm -rf $DLTEMP $EXTMPDIR
}

LOCALMTG() {
    local mtgtar=$1
    if [[ ! -f $mtgtar ]]; then mtgtar=$USER_PWD/$mtgtar; fi
    if [[ ! -f $mtgtar ]]; then
        red "> $mtgtar 文件不存在"
        exit 1
    fi
    yellow "> 检测到本地安装包,使用离线安装模式"

    EXTMPDIR=$(mktemp -d)
    trap 'echo 捕获到信号,正在清理 >&2; cd /; /bin/rm -rf "EXTMPDIR"; exit 15' 1 2 3 15

    yellow "> 正在解压..."
    tar xvf $mtgtar --strip-components=1 -C $EXTMPDIR

    systemctl stop mtg || true
    yellow "> 正在安装 MTG 二进制文件..."
    install -v -m755 $EXTMPDIR/mtg $BINEXEC
    yellow "> 清理临时文件..."
    rm -rf $EXTMPDIR
}

SHOWACCESS(){
    yellow "> 服务状态:"
    systemctl status mtg --no-pager -l | head -15
    echo ""
    yellow "> 在 Telegram 中使用以下代理链接: "

    # Try mtg access command first
    local mtg_output=$($BINEXEC access /etc/mtg.toml 2>/dev/null)
    
    if command -v jq > /dev/null 2>&1; then
        local ipv6_url=$(echo "$mtg_output" | jq -r '.ipv6.tme_url // empty' 2>/dev/null)
        local ipv4_url=$(echo "$mtg_output" | jq -r '.ipv4.tme_url // empty' 2>/dev/null)
        
        if [[ -n "$ipv6_url" ]]; then
            yellow "> IPv6 Access"
            echo "$ipv6_url"
        fi
        
        if [[ -n "$ipv4_url" ]]; then
            yellow "> IPv4 Access"
            echo "$ipv4_url"
        fi
        
        # If no URLs found, construct manually
        if [[ -z "$ipv4_url" && -z "$ipv6_url" ]]; then
            yellow "> mtg access 命令未返回链接,正在手动构造..."
            CONSTRUCT_URL
        fi
    else
        # Try to extract URLs without jq
        local has_url=$(echo "$mtg_output" | grep -c '"tme_url"' || true)
        
        if [[ $has_url -gt 0 ]]; then
            yellow "> IPv6 Access"
            echo "$mtg_output" | grep -A 20 '"ipv6"' | grep '"tme_url"' | sed 's/.*"tme_url": "\([^"]*\)".*/\1/' || echo "N/A"
            yellow "> IPv4 Access"
            echo "$mtg_output" | grep -A 20 '"ipv4"' | grep '"tme_url"' | sed 's/.*"tme_url": "\([^"]*\)".*/\1/' || echo "N/A"
        else
            yellow "> mtg access 命令未返回链接,正在手动构造..."
            CONSTRUCT_URL
        fi
    fi
    
    yellow "> 查看所有可用链接,运行 \`mtg access /etc/mtg.toml'"
    green "> 完成。"
}

CONSTRUCT_URL(){
    # Read PORT and SECRET from config file
    local PORT=$(grep 'bind-to' /etc/mtg.toml | sed 's/.*:\([0-9]*\)".*/\1/')
    local SECRET=$(grep '^secret' /etc/mtg.toml | sed 's/.*= "\(.*\)"/\1/')
    
    if [[ -z "$PORT" || -z "$SECRET" ]]; then
        red "> 无法从 /etc/mtg.toml 读取端口或密钥"
        yellow "> 请检查配置文件"
        return
    fi
    
    # Get server IP
    local SERVER_IP=$(curl -4 -s --max-time 5 ifconfig.me || curl -4 -s --max-time 5 ip.sb || curl -4 -s --max-time 5 icanhazip.com || echo "")
    
    if [[ -z "$SERVER_IP" ]]; then
        red "> 无法自动获取服务器 IP"
        yellow "> 请手动构造代理链接:"
        yellow "> 格式: tg://proxy?server=您的IP&port=$PORT&secret=$SECRET"
        return
    fi
    
    yellow "> 服务器 IP: $SERVER_IP"
    yellow "> 端口: $PORT"
    green "> 代理链接:"
    echo "tg://proxy?server=$SERVER_IP&port=$PORT&secret=$SECRET"
}

install_mtg() {
    arg1="${1:-}"
    
    if [[ -f /etc/mtg.toml ]]; then
        yellow "> 检测到已有配置 (/etc/mtg.toml),仅升级 MTG 二进制文件。"
        if [[ ! -z $arg1 ]]; then LOCALMTG $arg1; else DLMTG; fi
        yellow "> 已安装 MTG 版本: `$BINEXEC --version`"
        systemctl restart mtg
        yellow "> 升级成功。以下是最近的日志"
        SHOWACCESS
        return
    fi
    
    PORT=$(shuf -i 2000-65000 -n1)
    FAKEDOMAIN=hostupdate.vmware.com
    green "=================================================="
    yellow "> 输入服务端口,或按回车使用随机端口"
    PORT=$(DEFINPUT $PORT)
    yellow "> 输入 FakeTLS 域名,或按回车使用 \"$FAKEDOMAIN\""
    FAKEDOMAIN=$(DEFINPUT $FAKEDOMAIN)
    green "=================================================="
    yellow "> 使用配置: 端口: ${PORT}, FakeTLS 域名: ${FAKEDOMAIN}"
    green "=================================================="
    
    if [[ ! -z $arg1 ]]; then LOCALMTG $arg1; else DLMTG; fi
    yellow "> 已安装 MTG 版本: `$BINEXEC --version`"
    
    SECRET=$($BINEXEC generate-secret "$FAKEDOMAIN")
    
    # Check if conf directory exists (makeself mode) or create config inline
    if [[ -d "$__dir/conf" ]]; then
        # Running from makeself package
        sed -i "s/#PORT#/$PORT/;s/#SECRET#/$SECRET/" $__dir/conf/mtg.toml
        if [[ $(CalUnixTsDrifft) -gt 5 ]]; then
          skew=$(CalUnixTsDrifft)
          yellow ">>>> 此主机时间偏差 $skew 秒,正在设置 MTG 容忍度。"
          skew=$(($skew+5))
          sed -i "s/#SKEW#/${skew}s/" $__dir/conf/mtg.toml
        else
          sed -i "s/#SKEW#/5s/" $__dir/conf/mtg.toml
        fi
        install -v -m644 $__dir/conf/mtg.service /etc/systemd/system/
        install -v -m644 $__dir/conf/mtg.toml    /etc/
    else
        # Running standalone - create config files inline
        yellow "> 正在创建配置文件(独立模式)..."
        
        # Calculate time skew
        if [[ $(CalUnixTsDrifft) -gt 5 ]]; then
          skew=$(CalUnixTsDrifft)
          yellow ">>>> 此主机时间偏差 $skew 秒,正在设置 MTG 容忍度。"
          skew=$(($skew+5))
          SKEW="${skew}s"
        else
          SKEW="5s"
        fi
        
        # Create mtg.toml
        cat > /etc/mtg.toml << EOF
# refer to the example config for full documented config options
# https://github.com/9seconds/mtg/blob/master/example.config.toml
#

secret = "$SECRET"
bind-to = "0.0.0.0:$PORT"
concurrency = 8192
tcp-buffer = "128kb"
prefer-ip = "prefer-ipv4"
domain-fronting-port = 443
tolerate-time-skewness = "$SKEW"

[network]
doh-ip = "9.9.9.9"
proxies = [
    # "socks5://user:password@host:port?open_threshold=5&half_open_timeout=1m&reset_failures_timeout=10s"
]

[network.timeout]
tcp = "5s"
http = "10s"
idle = "1m"

[defense.anti-replay]
enabled = true
max-size = "1mib"
error-rate = 0.001

[defense.blocklist]
enabled = true
download-concurrency = 2
urls = [
    # "https://iplists.firehol.org/files/firehol_level1.netset",
    # "/local.file"
]
update-each = "24h"
EOF
        
        # Create mtg.service
        cat > /etc/systemd/system/mtg.service << EOF
[Unit]
Description=Bullshit-free MTPROTO proxy for Telegram
Documentation=https://github.com/9seconds/mtg
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Restart=always

; User and group the process will run as.
User=root
Group=root

ExecStart=/usr/local/bin/mtg run /etc/mtg.toml

; Limit the number of file descriptors; see \`man systemd.exec\` for more limit settings.
LimitNOFILE=1048576
; Unmodified caddy is not expected to use more than that.
LimitNPROC=512

[Install]
WantedBy=multi-user.target
EOF
        
        yellow "> 配置文件创建成功"
    fi
    
    systemctl daemon-reload
    systemctl enable mtg
    systemctl start mtg
    
    yellow "=================================================="
    green "> 安装成功。等待服务加载..."
    yellow "> 生成的密钥: ${SECRET}"
    yellow "> 监听端口: ${PORT}"
    yellow "=================================================="
    sleep 2
    SHOWACCESS
}

uninstall_mtg() {
    if [[ ! -f /etc/mtg.toml ]]; then
        yellow "MTG 未安装,无需卸载"
        return
    fi
    
    echo ""
    red "⚠️  警告: 此操作将完全删除 MTG 代理及其配置!"
    echo ""
    read -p "确认卸载? 输入 yes 继续: " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        yellow "已取消卸载"
        return
    fi
    
    yellow "> 正在停止服务..."
    systemctl stop mtg 2>/dev/null || true
    systemctl disable mtg 2>/dev/null || true
    
    yellow "> 正在删除文件..."
    rm -f /usr/local/bin/mtg
    rm -f /etc/systemd/system/mtg.service
    rm -f /etc/mtg.toml
    
    systemctl daemon-reload
    
    green "✓ MTG 已成功卸载"
}

show_status() {
    if [[ ! -f /etc/mtg.toml ]]; then
        yellow "MTG 未安装"
        return
    fi
    
    SHOWACCESS
}

restart_service() {
    if [[ ! -f /etc/mtg.toml ]]; then
        yellow "MTG 未安装"
        return
    fi
    
    yellow "> 正在重启 MTG 服务..."
    systemctl restart mtg
    sleep 1
    green "✓ 服务已重启"
    echo ""
    systemctl status mtg --no-pager -l | head -10
}

show_menu() {
    clear
    green "=================================================="
    green "         MTG Telegram 大灰狼专用脚本"
    green "=================================================="
    echo ""
    yellow "请选择操作:"
    echo "  1) 安装 MTG 代理"
    echo "  2) 卸载 MTG 代理"
    echo "  3) 查看状态和代理链接"
    echo "  4) 重启 MTG 服务"
    echo "  0) 退出"
    echo ""
    read -p "请输入选项 [0-4]: " choice
}

pause_menu() {
    echo ""
    read -p "按回车键返回主菜单..." dummy
}

# Main menu loop
main() {
    while true; do
        show_menu
        case $choice in
            1)
                clear
                green "========== 安装 MTG 代理 =========="
                echo ""
                install_mtg "$@"
                pause_menu
                ;;
            2)
                clear
                green "========== 卸载 MTG 代理 =========="
                uninstall_mtg
                pause_menu
                ;;
            3)
                clear
                green "========== 状态和代理链接 =========="
                echo ""
                show_status
                pause_menu
                ;;
            4)
                clear
                green "========== 重启服务 =========="
                echo ""
                restart_service
                pause_menu
                ;;
            0)
                green "再见!"
                exit 0
                ;;
            *)
                red "无效选项,请重试"
                sleep 1
                ;;
        esac
    done
}

# Run main menu
main "$@"
