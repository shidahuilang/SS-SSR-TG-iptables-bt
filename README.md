- 使用root用户登录ubuntu或者debian系统，后执行以下命令安装curl
```sh
apt -y update && apt -y install curl wget
```

- 使用root用户登录centos系统，后执行以下命令安装curl
```sh
yum install -y curl wget
```
## 38合1多功能脚本集合你想要的都在这里

![img1.jpg](img1.jpg)
- 脚本说明: 多合一脚本，DD系统，BBR，xray,TG搭建等等·常用的各种脚本基本都有！
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+
- 支持安装BBR，搭建KCPtun，ssr多用户版
- 安装V2ary，Tg专用代理（Go版），安装Goflyway
- 小鸡性能测试，回程线路测试，云监控
- 傻瓜式一键DD包
- 一键开启默认bbr
- Netflix解锁检测
- xray安装
- 宝塔面板，闲蛋面板，x-ui面板，WARP 一键配置

#### 脚本特点:
目前网上的各个一键脚本基本都是只有 安装/启动/重启 等基础功能，对于小白来说还是不够简单方便。常用的各种脚本基本都有！


#### 下载安装:
- 国内鸡
``` bash
bash <(curl -sSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/DD.sh)
```
- 国外鸡
``` bash
bash <(curl -s -L https://git.io/JPj82)
```
#### 京东服务器时间同步
``` bash
bash -c "$(curl -fsSL git.io/JDIXU)"
```
## FRP内网穿刺

- Frps服务端一键配置脚本
- Frp 是一个高性能的反向代理应用，可以帮助您轻松地进行内网穿透，对外网提供服务，支持 tcp, http, https 等协议类型，并且 web 服务支持根据域名进行路由转发。
- 系统支持: CentOS6+ / Debian6+ / Ubuntu(32bit/64bit)
#### 下载安装:
- Aliyun
``` bash
wget https://code.aliyun.com/MvsCode/frps-onekey/raw/master/install-frps.sh -O ./install-frps.sh && chmod 700 ./install-frps.sh && bash install-frps.sh install
```
- Github
``` bash
wget -N --no-check-certificate https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/frps/install-frps.sh -O ./install-frps.sh && chmod 700 ./install-frps.sh && bash install-frps.sh install
```
- （卸载）
```sh
./install-frps.sh uninstall
```
- （更新）
```sh
./install-frps.sh update
```
- 服务管理
Usage: /etc/init.d/frps {start|stop|restart|status|config|version}

## nps内网穿刺
- 一款轻量级、高性能、功能强大的内网穿透代理服务器
- 支持tcp、udp、socks5、http等几乎所有流量转发，可用来访问内网网站
- 本地支付接口调试、ssh访问、远程桌面，内网dns解析、内网socks5代理等等
- WEB:IP:8080  账号admin  密码123
### 下载安装
``` bash
wget -P /root -N --no-check-certificate "https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_server.tar.gz" && tar -zxvf linux_amd64_server.tar.gz && ./nps install && nps start
```
- 注册：sudo ./nps install 其他参数（例如-server=xx -vkey=xx或者-config=xxx）
- 启动：sudo nps start
- 停止：sudo nps stop
- 卸载：nps uninstall
- 更新：sudo nps stop + sudo npc-update update

## Docker-Compose一键安装

- 系统支持: CentOS6+ / Debian6+ / Ubuntu
- 一键更换国内软件源
- 脚本集成安装 Docker Engine Docker Compose
#### 下载安装:
``` bash
bash <(curl -sSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/DockerInstallation.sh)
```
#### 一键切换国内源:
``` bash
bash <(curl -sSL git.io/JPjlC)
```

## 代理相关

## 八合一脚本

- 八合一共存脚本+伪装站点
- 系统支持: CentOS6+ / Debian6+ / Ubuntu

#### 脚本特点:
- VLESS+TCP+TLS
- VLESS+TCP+xtls-rprx-direct【推荐】
- VLESS+gRPC+TLS【支持CDN、IPv6、延迟低】
- VLESS+WS+TLS【支持CDN、IPv6】
- Trojan+TCP+TLS【推荐】
- Trojan+TCP+xtls-rprx-direct【推荐】
- Trojan+gRPC+TLS【支持CDN、IPv6、延迟低】
- VMess+WS+TLS【支持CDN、IPv6】
#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjlh)
```


## ss_go一键安装

- 脚本说明: Shadowsocks 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+

#### 脚本特点:
目前网上的各个Shadowsocks脚本基本都是只有 安装/启动/重启 等基础功能，对于小白来说还是不够简单方便。既然是一键脚本，那么就要尽可能地简单，小白更容易接受使用！

#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj8D)
```
## ssrmu一键安装
- 脚本说明: Shadowsocks 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+ /arm
``` bash
bash <(curl -s -L git.io/JX0Po)
```
---
## ssr一键安装

- 脚本说明: ShadowsocksR 一键安装管理脚本，支持单端口/多端口切换和管理
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 脚本特点:
目前网上的各个ShadowsocksR脚本基本都是只有 安装/启动/重启 等基础功能，对于小白来说还是不够简单方便。既然是一键脚本，那么就要尽可能地简单，小白更容易接受使用！

- 支持 限制 用户速度
- 支持 限制 端口设备数
- 支持 显示 当前连接IP
- 支持 显示 SS/SSR连接+二维码
- 支持 切换管理 单/多端口
- 支持 一键安装 锐速
- 支持 一键安装 BBR
- 支持 一键封禁 垃圾邮件(SMAP)/BT/PT

#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj87)
```

## V2Ray一键安装
- 脚本说明:V2Ray 一键安装脚本 & 管理脚本 功能特点 支持 V2Ray 多数传输协议
- 系统支持:Ubuntu 16+ / Debian 8+ / CentOS 7+ 系统

 - 输入 v2ray 查看面板

 - v2ray info 查看 V2Ray 配置信息

 - v2ray config 修改 V2Ray 配置

 - v2ray link 生成 V2Ray 配置文件链接

 - v2ray infolink 生成 V2Ray 配置信息链接

 - v2ray qr 生成 V2Ray 配置二维码链接

 - v2ray ss 修改 Shadowsocks 配置

 - v2ray ssinfo 查看 Shadowsocks 配置信息

 - v2ray ssqr 生成 Shadowsocks 配置二维码链接

 - v2ray status 查看 V2Ray 运行状态

 - v2ray start 启动 V2Ray

 - v2ray stop 停止 V2Ray

 - v2ray restart 重启 V2Ray

 - v2ray uninstall 卸载 V2Ray

#### 下载安装
``` bash
bash <(curl -s -L https://git.io/Jicox)
```


## x-ui面板一键安装

- 系统状态监控
- 支持多用户多协议，网页可视化操作
- 支持的协议：vmess、vless、trojan、shadowsocks、dokodemo-door、socks、http
- 支持配置更多传输配置
- 流量统计，限制流量，限制到期时间
- 可自定义 xray 配置模板
- 支持 https 访问面板（自备域名 + ssl 证书）

## 使用教程
## 下载安装
- 方法1 一键全部安装
``` bash
bash <(curl -s -L https://git.io/J1wy9)
```
- 方法2 分步奏安装
``` bash
bash <(curl -s -L git.io/JPj4L)

curl https://get.acme.sh | sh

~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com

~/.acme.sh/acme.sh  --issue -d 你的域名   --standalone

~/.acme.sh/acme.sh --installcert -d 你的域名 --key-file /root/private.key --fullchain-file /root/cert.crt
```
- 顺利安装完成后，用IP+54321 端口登录页面，修改好用户名、密码、面板监听端口、面板证书公钥文件路径、面板证书密钥文件路径

- 重启页面，然后就可以用你的域名+面板监听端口和你新设置的用户名跟密码登录页面了


## brook一键安装

- 脚本说明: Brook 一键安装管理脚本
- 系统支持: CentOS6+ / Debian7+ / Ubuntu14+

#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj4g)
```

---
## goflyway一键安装

- 脚本说明: GoFlyway 一键安装管理脚本
- 系统支持: CentOS6+ / Debian7+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj4o)
```

---
## lightsocks一键安装

- 脚本说明: LightSocks 一键安装管理脚本
- 系统支持: CentOS6+ / Debian7+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj4i)
```

---
## daze一键安装

- 脚本说明: DAZE 一键安装管理脚本
- 系统支持: CentOS6+ / Debian7+ / Ubuntu14+

#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj4D)
```

---
## mtproxy一键安装

- 脚本说明: Mtproto Proxy 一键安装管理脚本
- 系统支持: CentOS7 / Debian7+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjRa)
```

---
## mtproxy_go一键安装

- 脚本说明: Mtproto Proxy Go版 一键安装管理脚本
- 系统支持: CentOS6+ / Debian7+ / Ubuntu14+
- 输入命令后显示：`> Input service PORT, or press Enter to use a random port` 这个是输入您要设置端口，不设置的话回车默认端口
- 然后显示：`> Input a domain for FakeTLS, or press Enter to use "hostupdate.vmware.com"` 回车默认hostupdate.vmware.com，可以输入 FakeTLS 改协议
- 搭建好以后要查看TG代理链接，输入：mtg access /etc/mtg.toml


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj0I)
```

---

## 中转相关

## 闲蛋面板一键安装

- 脚本说明:闲蛋面板一键部署
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+

#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj0u)
```

## iptables端口转发一键安装

- 脚本说明: iptables 端口转发 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj0a)
```

---
## brook-pf一键安装

- 脚本说明: Brook 端口转发 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj06)
```

---
## haproxy一键安装

- 脚本说明: HaProxy 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj0y)
```

---
## socat一键安装

- 脚本说明: Socat 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj0b)
```

---
## tinymapper一键安装

- 脚本说明: tinyPortMapper 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPj0p)
```

---

## BT下载相关

## aria2一键安装

- 脚本说明: Aria2 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjEJ)
```

---
## cloudt一键安装

- 脚本说明: Cloud Torrent 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjEL)
```

---
## pserver一键安装

- 脚本说明: Peerflix Server 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjEO)
```

---

## 服务器相关

## bbr一键安装

- 脚本说明: BBR 一键安装管理脚本
- 系统支持: Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjEW)
```

---
## status云监控探针一键安装
- ServerStatus中文版是一个酷炫高逼格的云探针、云监控、服务器云监控、多服务器探针
- 脚本说明: ServerStatus 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjWi)
```

---
## ban_iptables一键安装

- 脚本说明: iptables 垃圾邮件(SPAM)/BT/PT 一键封禁脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjEu)
```

---
## ssh_port一键安装

- 脚本说明: SSH 一键修改端口脚本
- 系统支持: Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjul)
```

---

## VPN相关

## ocserv一键安装

- 脚本说明: Ocserv AnyConnect 一键安装管理脚本
- 系统支持: Debian7+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPju0)
```

## L2TP一键安装 

-L2TP一键安装
- 脚本说明: L2TP一键安装脚本: 支持的系统：CentOS 6+ / Debian 7+ / Ubuntu 12+
``` bash
bash <(curl -s -L git.io/JPjuV)
```
---

## DNS相关

## dowsdns一键安装

- 脚本说明: DowsDNS 一键安装管理脚本
- 系统支持: CentOS7 / Debian7+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPju1)
```

---

## HTTP相关

## caddy_install一键安装

- 脚本说明: Caddy 一键安装脚本
- 系统支持: CentOS6+ / Debian7+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjuy)
 # 安装插件：
 bash caddy_install.sh xxx,xxx
  # 例如同时安装 http.filemanager 和 http.webdav插件：
  bash caddy_install.sh http.filemanager,http.webdav
  # 插件和Caddy是集成在一起的(单个二进制文件)，多个插件必须同时安装。
# 卸载命令：
wget -N --no-check-certificate https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/caddy_install.sh && chmod +x caddy_install.sh && caddy_install.sh uninstall
```

---
## pythonhttp一键安装

- 脚本说明: SimpleHTTPServer 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzU)
```

---

## 其他

## 订阅转换网站一键安装

- 脚本说明: 节点转换搭建前后端
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+
- 首先您要有域名跟解析好两个子域名，分别为一个前端（登录网页用），一个后端（服务器IP用）
- 需要安装宝塔、Nginx和占用443端口，要看清楚跟你现在服务器的有没有冲突

- 运行第一个命令，顺利运行后《[看这里](https://github.com/shidahuilang/SS-SSR-TG-iptables-bt/blob/main/clash/taota01.png)》
``` bash
bash <(curl -fsSL git.io/JPMAe)
```
---
- 运行第二个命令，顺利运行后《[看这里](https://github.com/shidahuilang/SS-SSR-TG-iptables-bt/blob/main/clash/clash.md)》
``` bash
bash <(curl -fsSL git.io/JPMAG)
```
---
- 运行第三个命令，就已经完事了
``` bash
bash <(curl -fsSL git.io/JPMAF)
```

## gfw_push一键安装

- 脚本说明: 监测服务器IP是否被墙并推送至 Telegram 一键脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzm)
```

---
## libsodium一键安装

- 脚本说明: libsodium 一键安装管理脚本
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzG)
```

---
## ssr_check一键安装

- 脚本说明: ShadowsocksR 批量快速验证账号可用性
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzn)
```

---
## ssrstatus一键安装

- 脚本说明: ShadowsocksR 账号在线监控网站
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzW)
```

---
## ssr_ip_check一键安装

- 脚本说明: ShadowsocksR 检测每个端口链接IP数
- 系统支持: CentOS6+ / Debian6+ / Ubuntu14+


#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzB)
```

---
## vps测速

- 脚本说明: VPS一键测速脚本
- 系统支持: CentOS7 / Debian7+ / Ubuntu14+

#### 下载安装:
``` bash
bash <(curl -s -L git.io/JPjzE)
```
## 流媒体检测

- 脚本说明: 流媒体检测
``` bash
bash <(curl -s -L git.io/JPjzo)
```
## CF自动优选IP
- 脚本说明：CF自动优选IP并自动在PassWall进行部署
- 开启 CloudFlare 的 “小云朵”，开启我们的 CDN。
- 查看 软路由 PassWall 的自定义节点字符串。
``` bash
vi /etc/config/passwall
```
- 在软路由里面下载 cf-auto-passwall 脚本
``` bash
wget https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/cf-auto-passwall.sh
```
- 编辑该脚本
- 更改相关的参数（默认优选带宽大小、节点相对应的字符串），并保存
``` bash
vi cf-auto-passwall.sh
```
- 软路由运行
``` bash
chmod +x cf-auto-passwall.sh && bash cf-auto-passwall.sh
```
- 软路由设置计划任务（凌晨4点更新IP）
``` bash
0 04 * * * bash /root/cf-auto-passwall.sh > /dev/null
```
