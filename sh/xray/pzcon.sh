#!/bin/bash

tcpBase64Default=$(echo -n "{\"add\":\"${domain}\",\"aid\":0,\"host\":\"${domain}\",\"id\":\"${UUID}\",\"net\":\"tcp\",\"path\":\"${VMESS_TCP_PATH}\",\"port\":${PORT},\"ps\":\"VMESS_TCP_${domain}\",\"scy\":\"none\",\"sni\":\"${domain}\",\"tls\":\"tls\",\"v\":2,\"type\":\"http\",\"allowInsecure\":0,\"peer\":\"${domain}\",\"obfs\":\"http\",\"obfsParam\":\"${domain}\"}" | base64)
Vmess_tcp="${tcpBase64Default// /}"

wsBase64Default=$(echo -n "{\"port\":${PORT},\"ps\":\"VMESS_WS_${domain}\",\"tls\":\"tls\",\"id\":\"${UUID}\",\"aid\":0,\"v\":2,\"host\":\"${domain}\",\"type\":\"none\",\"path\":\"${VMESS_WS_PATH}\",\"net\":\"ws\",\"add\":\"${domain}\",\"allowInsecure\":0,\"method\":\"none\",\"peer\":\"${domain}\",\"sni\":\"${domain}\"}" | base64 -w 0)
Vmess_ws="${wsBase64Default// /}"

cat >/usr/local/etc/xray/pzcon <<-EOF
#!/bin/bash
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
echo -e "\033[31m （4）VLESS+WS+TLS \033[0m"
echo
echo "vless://${UUID}@${domain}:${PORT}?encryption=none&security=tls&type=ws&host=${domain}&sni=${domain}&path=${VLESS_WS_PATH}#VLESS_WS_TLS_${domain}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=vless://${UUID}@${domain}:${PORT}?encryption=none&security=tls&type=ws&host=${domain}&sni=${domain}&path=${VLESS_WS_PATH}#VLESS_WS_TLS_${domain} \033[0m"
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
echo -e "\033[33m 传输协议：WebSocket/ws \033[0m"
echo -e "\033[33m WebSocket Host：${domain} \033[0m"
echo -e "\033[33m WebSocket Path：${VLESS_WS_PATH} \033[0m"
echo
echo
echo
echo -e "\033[31m （5）VMESS+TCP+TLS \033[0m"
echo
echo "vmess://${Vmess_tcp}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=vmess://${Vmess_tcp} \033[0m"
echo
echo -e "\033[33m 节点备注/别名：VLESS+TCP+TLS${PORT}（可自行修改） \033[0m"
echo -e "\033[33m 节点类型：XRay \033[0m"
echo -e "\033[33m 协议：VMESS \033[0m"
echo -e "\033[33m 服务器地址：${domain} \033[0m"
echo -e "\033[33m 服务器端口：${PORT} \033[0m"
echo -e "\033[33m UUID：${UUID} \033[0m"
echo -e "\033[33m 加密方式：AUTO \033[0m"
echo -e "\033[33m 传输协议：TCP \033[0m"
echo -e "\033[33m 伪装类型：HTTP \033[0m"
echo -e "\033[33m HTTP Host：${domain} \033[0m"
echo -e "\033[33m HTTP Path：${VMESS_TCP_PATH} \033[0m"
echo -e "\033[33m TLS：勾选 \033[0m"
echo -e "\033[33m 指纹伪造：禁用 \033[0m"
echo -e "\033[33m TLS Host：${domain} \033[0m"
echo
echo
echo
echo -e "\033[31m （6）VMESS+WS+TLS（可套cloudflare CDN使用） \033[0m"
echo
echo "vmess://${Vmess_ws}"
echo
echo -e "\033[32m 二维码链接(浏览器打开):https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=vmess://${Vmess_ws} \033[0m"
echo
echo -e "\033[33m 节点备注/别名：VLESS+WS+TLS${PORT}（可自行修改） \033[0m"
echo -e "\033[33m 节点类型：XRay \033[0m"
echo -e "\033[33m 协议：VMESS \033[0m"
echo -e "\033[33m 服务器地址：${domain} \033[0m"
echo -e "\033[33m 服务器端口：${PORT} \033[0m"
echo -e "\033[33m UUID：${UUID} \033[0m"
echo -e "\033[33m 加密方式：AUTO \033[0m"
echo -e "\033[33m 传输协议：WebSocket/ws \033[0m"
echo -e "\033[33m WebSocket Path：${VMESS_WS_PATH} \033[0m"
echo -e "\033[33m TLS：勾选 \033[0m"
echo -e "\033[33m 指纹伪造：禁用 \033[0m"
echo -e "\033[33m TLS Host：${domain} \033[0m"
echo
echo
echo -e "\033[31m 总共6条节点信息,请往上翻查看  \033[0m"
echo
echo
echo -e "\033[32m 友情提示：再次输入安装命令或者输入[glxray]命令可以对程序进行管理  \033[0m"
echo
echo
EOF
