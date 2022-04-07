#!/bin/bash
cat >/usr/local/etc/xray/pzcon <<-EOF
#!/bin/bash
# 此文件请勿删除和做任何修改
echo
echo
echo -e "\033[41;33m 信息查询于：$(date +%Y年%m月%d号%H时%M分%S秒)  \033[0m"
echo
echo
echo -e "\033[31m （1）Trojan-Plus \033[0m"
echo
echo "trojan://${QJPASS}@${domain}:${PORT}/?sni=${domain}&tls=1&allowinsecure=1#trojan_${domain}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=trojan://${QJPASS}@${domain}:${PORT}/?sni=${domain}&tls=1&allowinsecure=1#trojan_${domain} \033[0m"
echo
echo -e "\033[33m 节点备注/别名：Trojan+${PORT}（可自行修改） \033[0m"
echo -e "\033[33m 节点类型：Trojan-Plus \033[0m"
echo -e "\033[33m 地址（支持域名）：${domain} \033[0m"
echo -e "\033[33m 服务器端口：${PORT} \033[0m"
echo -e "\033[33m 密码：${QJPASS} \033[0m"
echo -e "\033[33m TCP快速打开：false \033[0m"
echo -e "\033[33m TLS：勾选 \033[0m"
echo -e "\033[33m Session Ticket：不勾选 \033[0m"
echo -e "\033[33m 域名：${domain} \033[0m"
echo
echo
echo
echo -e "\033[31m （2）VLESS+TCP+XTLS \033[0m"
echo
echo "vless://${UUID}@${domain}:${PORT}?headerType=none&type=tcp&encryption=none&flow=xtls-rprx-direct&security=xtls&sni=${domain}#VLESS_TCP_XTLS_${domain}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=vless://${UUID}@${domain}:${PORT}?headerType=none&type=tcp&encryption=none&flow=xtls-rprx-direct&security=xtls&sni=${domain}#VLESS_TCP_XTLS_${domain} \033[0m"
echo
echo -e "\033[33m 节点备注/别名：VLESS+TCP+XTLS${PORT}（可自行修改） \033[0m"
echo -e "\033[33m 节点类型：XRay \033[0m"
echo -e "\033[33m 协议：VLESS \033[0m"
echo -e "\033[33m 服务器地址：${domain_ip} \033[0m"
echo -e "\033[33m 服务器端口：${PORT} \033[0m"
echo -e "\033[33m 加密方式：none \033[0m"
echo -e "\033[33m UUID：${UUID} \033[0m"
echo -e "\033[33m TLS：勾选 \033[0m"
echo -e "\033[33m XTLS：勾选 \033[0m"
echo -e "\033[33m 流控(flow)：xtls-rprx-direct \033[0m"
echo -e "\033[33m alpn：默认 \033[0m"
echo -e "\033[33m 域名：${domain} \033[0m"
echo -e "\033[33m 传输协议：TCP \033[0m"
echo -e "\033[33m 伪装协议：none/none \033[0m"
echo
echo
echo
echo -e "\033[31m （3）VLESS+TPC+TLS \033[0m"
echo
echo "vless://${UUID}@${domain}:${PORT}?headerType=none&type=tcp&encryption=none&security=tls&sni=${domain}#VLESS_TPC_TLS_${domain}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=vless://${UUID}@${domain}:${PORT}?headerType=none&type=tcp&encryption=none&security=tls&sni=${domain}#VLESS_TPC_TLS_${domain} \033[0m"
echo
echo -e "\033[33m 节点备注/别名：VLESS+TPC+TLS${PORT}（可自行修改） \033[0m"
echo -e "\033[33m 节点类型：XRay \033[0m"
echo -e "\033[33m 协议：VLESS \033[0m"
echo -e "\033[33m 服务器地址：${domain} \033[0m"
echo -e "\033[33m 服务器端口：${PORT} \033[0m"
echo -e "\033[33m 加密方式：none \033[0m"
echo -e "\033[33m UUID：${UUID} \033[0m"
echo -e "\033[33m TLS：勾选 \033[0m"
echo -e "\033[33m XTLS：不选 \033[0m"
echo -e "\033[33m alpn：默认 \033[0m"
echo -e "\033[33m 域名：${domain} \033[0m"
echo -e "\033[33m 传输协议：TCP \033[0m"
echo -e "\033[33m 伪装协议：none/none \033[0m"
echo
echo
echo
echo -e "\033[31m （4）VLESS+WS+TLS（可套CF使用） \033[0m"
echo
echo "vless://${UUID}@${domain}:${PORT}?host=${domain}&path=%2F${WS_PATH}%2F&type=ws&encryption=none&security=tls&sni=${domain}#VLESS_WS_TLS_${domain}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=vless://${UUID}@${domain}:${PORT}?host=${domain}&path=%2F${WS_PATH}%2F&type=ws&encryption=none&security=tls&sni=${domain}#VLESS_WS_TLS_${domain} \033[0m"
echo
echo -e "\033[33m 节点备注/别名：VLESS+WS+TLS${PORT}（可自行修改） \033[0m"
echo -e "\033[33m 节点类型：XRay \033[0m"
echo -e "\033[33m 协议：VLESS \033[0m"
echo -e "\033[33m 服务器地址：${domain} \033[0m"
echo -e "\033[33m 服务器端口：${PORT} \033[0m"
echo -e "\033[33m 加密方式：none \033[0m"
echo -e "\033[33m UUID：${UUID} \033[0m"
echo -e "\033[33m TLS：勾选 \033[0m"
echo -e "\033[33m XTLS：不选 \033[0m"
echo -e "\033[33m alpn：默认 \033[0m"
echo -e "\033[33m 域名：${domain} \033[0m"
echo -e "\033[33m 传输协议：WebSocket \033[0m"
echo -e "\033[33m WebSocket Host：${domain} \033[0m"
echo -e "\033[33m WebSocket Path：/${WS_PATH}/ \033[0m"
echo
echo -e "\033[32m 总共4条信息查询完毕,往上翻查看  \033[0m"
echo
EOF
