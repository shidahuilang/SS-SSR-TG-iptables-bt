#!/usr/bin/env bash
set -e

echo "====================================="
echo "   3X-UI Docker 一键安装脚本"
echo "====================================="

# 当前目录
BASE_DIR=$(pwd)

# 创建目录
mkdir -p ${BASE_DIR}/db
mkdir -p ${BASE_DIR}/cert

echo "[1/4] 目录准备完成"

# 检查 docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

echo "[2/4] Docker 已检测"

# 拉取镜像
echo "[3/4] 拉取 3x-ui 镜像..."
docker pull ghcr.io/mhsanaei/3x-ui:latest

# 如果已存在则删除
if docker ps -a | grep -q 3x-ui; then
    echo "⚠️ 已存在旧容器，正在删除..."
    docker rm -f 3x-ui
fi

# 启动容器
echo "[4/4] 启动 3x-ui..."

docker run -itd \
 -e XRAY_VMESS_AEAD_FORCED=false \
 -e XUI_ENABLE_FAIL2BAN=true \
 -v ${BASE_DIR}/db:/etc/x-ui \
 -v ${BASE_DIR}/cert:/root/cert \
 --network=host \
 --restart=unless-stopped \
 --name 3x-ui \
 ghcr.io/mhsanaei/3x-ui:latest

# 获取IP
IP=$(curl -s ipv4.ip.sb || curl -s ifconfig.me || hostname -I | awk '{print $1}')

echo ""
echo "====================================="
echo "🎉 3X-UI 安装完成"
echo "====================================="
echo "🌐 访问地址:  http://${IP}:2053"
echo "👤 用户名:   admin"
echo "🔑 密码:     admin"
echo "====================================="
