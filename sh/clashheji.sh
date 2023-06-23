#!/bin/bash

echo "请选择安装方式："
echo "1. Linux版本"
echo "2. Docker版本"
read -p "请输入数字选择：" choice

case $choice in
    1)
        echo "您选择了Linux版本"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/clash_install.sh)"
        ;;
    2)
        echo "您选择了Docker版本"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/pve/main/docker-clash.sh)"
        ;;
    *)
        echo "输入无效，退出脚本"
        exit 1
        ;;
esac
