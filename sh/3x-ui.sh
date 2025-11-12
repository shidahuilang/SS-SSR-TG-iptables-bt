#!/usr/bin/env bash
# ----------------------------------------------------------
# 3x-ui 安装脚本：支持 Shell 原生安装 或 Docker-CLI 安装
# 默认端口：2053，默认账号/密码：admin / admin
# ----------------------------------------------------------
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

has_docker() { command -v docker &>/dev/null; }

install_shell() {
    info "开始 Shell 版安装 3x-ui …"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    info "安装完成！"
    info "默认面板地址：http://<服务器IP>:2053"
    info "默认账号：admin   默认密码：admin"
}

install_docker() {
    info "开始 Docker-CLI 版安装 3x-ui …"
    mkdir -p "$PWD/db" "$PWD/cert"

    if netstat -tuln 2>/dev/null | grep -q ':2053 '; then
        warn "宿主机 2053 端口已被占用，请先处理后再运行脚本"
        exit 1
    fi

    docker run -itd \
        -e XRAY_VMESS_AEAD_FORCED=false \
        -e XUI_ENABLE_FAIL2BAN=true \
        -v "$PWD/db/:/etc/x-ui/" \
        -v "$PWD/cert/:/root/cert/" \
        --network=host \
        --restart=unless-stopped \
        --name 3x-ui \
        ghcr.io/mhsanaei/3x-ui:latest

    info "Docker 容器已启动，名称：3x-ui"
    info "默认面板地址：http://<服务器IP>:2053"
    info "默认账号：admin   默认密码：admin"
}

main() {
    echo "======================================================"
    echo "        3x-ui 一键安装脚本（Shell 版 / Docker 版）"
    echo "        默认端口：2053 | 默认账号/密码：admin/admin"
    echo "======================================================"
    echo "1) Shell 原生安装（快速，适合纯净系统）"
    echo "2) Docker-CLI 安装（隔离性好，需已装 Docker）"
    echo "======================================================"
    read -rp "请选择安装方式 [1/2]：" choice

    case "$choice" in
        1) install_shell ;;
        2)
            if ! has_docker; then
                error "本机未检测到 Docker，请先安装 Docker 后再运行本脚本"
                exit 1
            fi
            install_docker
            ;;
        *) error "输入无效，请输入 1 或 2"; exit 1 ;;
    esac

    info "安装流程结束，祝使用愉快！"
}

main "$@"