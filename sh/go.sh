#!/bin/bash

# 定义变量
GO_VERSION="1.24.4"
GO_TAR_FILE="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://mirrors.aliyun.com/golang/${GO_TAR_FILE}"

# 下载 Go（显示进度条）
echo "正在从阿里云镜像下载 Go ${GO_VERSION}..."
wget -O "/tmp/${GO_TAR_FILE}" "${GO_URL}"

# 检查下载是否成功
if [ $? -ne 0 ]; then
  echo "下载失败，请检查网络连接或链接是否有效。"
  exit 1
fi

# 解压并安装 Go
echo "正在安装 Go ${GO_VERSION}..."
sudo tar -C /usr/local -xzf "/tmp/${GO_TAR_FILE}"

# 配置全局环境变量
echo "正在配置全局 Go 环境变量..."
echo 'export GOROOT=/usr/local/go' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$GOROOT/bin' | sudo tee -a /etc/profile

# 重新加载全局配置文件
echo "重新加载全局配置文件..."
source /etc/profile

# 验证安装
echo "正在验证 Go 安装..."
go version

# 清理下载文件
echo "清理下载文件..."
rm -f "/tmp/${GO_TAR_FILE}"

echo "Go ${GO_VERSION} 已全局安装完成！"