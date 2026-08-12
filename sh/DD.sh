#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


sh_ver="2.0.9"

# 颜色定义
red() { echo -e "\033[31m$*\033[0m"; }
green() { echo -e "\033[32m$*\033[0m"; }
yellow() { echo -e "\033[33m$*\033[0m"; }
blue() { echo -e "\033[34m$*\033[0m"; }
cyan() { echo -e "\033[36m$*\033[0m"; }
bold() { echo -e "\033[1m$*\033[0m"; }

# 兼容旧版颜色变量
Green_font_prefix="\033[32m"
Font_color_suffix="\033[0m"





#0升级脚本
Update_Shell(){
	sh_new_ver=$(wget --no-check-certificate -qO- -t1 -T3 "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/DD.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="github"
	[[ -z ${sh_new_ver} ]] && red "❌ 无法连接到 Github!" && exit 0
	wget -N --no-check-certificate "https://raw.githubusercontent.com/veip007/hj/master/hj.sh" && chmod +x hj.sh
	green "✓ 脚本已更新为最新版本 [ ${sh_new_ver} ]"
}
 #1安装BBR 锐速
bbr_ruisu(){
	bash <(curl -s -L https://raw.githubusercontent.com/veip007/Linux-NetSpeed/master/tcp.sh)
}
#2一键提升VPS速度
tools(){
	wget -N --no-check-certificate https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/tools.sh && chmod +x tools.sh && bash tools.sh
}
#3Cloudflare WARP 一键配置
warp.sh(){
	bash <(curl -fsSL git.io/warp.sh) menu
}
#4安装SS
ubuntu_install_ss.sh(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/ubuntu_install_ss.sh)
}
#5安装ssrmu（arm）
ssrmu(){
        bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/ssrmu.sh)
}
#6安装V2ary_233一键
Install_V2ray(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/V2Ray.sh)
}
#7安装MTG专用代理
Tg_socks(){
	(curl -LfsS https://raw.githubusercontent.com/0xdabiaoge/MTProxy/main/mtp.sh -o /usr/local/bin/mtp || wget -q https://raw.githubusercontent.com/0xdabiaoge/MTProxy/main/mtp.sh -O /usr/local/bin/mtp) && chmod +x /usr/local/bin/mtp && mtp
}
#8安装MTG专用代理（docker版）
mtproxy(){
        wget -N --no-check-certificate https://raw.githubusercontent.com/shidahuilang/mtg/refs/heads/main/tg.install.sh && chmod +x tg.install.sh && bash tg.install.sh
}
#9PVE开启直通
pve(){
	bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/pve/main/pve.sh)"
}
#10黑群晖cpu正确识别
ch_cpuinfo_cn(){
	wget -qO ch_cpuinfo_cn.sh https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/pve/main/ch_cpuinfo_cn.sh && sudo bash ch_cpuinfo_cn.sh
}

#11回程线路测试
View_huicheng(){
	wget -N --no-check-certificate https://raw.githubusercontent.com/veip007/huicheng/master/huicheng && chmod +x huicheng
}
#12安装哪吒探针
nezha(){
	curl -L https://gitee.com/naibahq/scripts/raw/main/install.sh -o nezha.sh && chmod +x nezha.sh && sudo CN=true ./nezha.sh
}
#13一键DD包（OD源）
DD_OD(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/dd-od.sh)
}
#14甲骨文一键DD到Debian 11
DD_GD(){
	bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/07031218/normal-shell/main/InstallNET.sh') -d 11 -v 64 -p password
}
#15一键设置交换虚拟分区
swap(){
	bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/pve/main/swap.sh)"
}
#16pve和群辉相关脚本
set(){
	bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/pve/main/set.sh)"
}
# 17Netflix解锁检测
netflix(){
        bash <(curl -sSL "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/netflix.sh")	
}
#18CF自动优选
cf(){
bash <(curl -sSL "https://proxy.freecdn.workers.dev/?url=https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/cf.sh")	
}
#19VPS一键3网测速脚本
superspeed(){
	wget -qO- bench.sh | bash
}
#20FRP内网穿刺
install-frps(){
        wget -N --no-check-certificate https://gitee.com/mvscode/frps-onekey/raw/master/install-frps.sh -O ./install-frps.sh && chmod 700 ./install-frps.sh && bash install-frps.sh install
}
#21Docker-Compose安装
DockerInstallation(){
       bash <(curl -sSL https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/DockerInstallation.sh)
}
#22X-ui面板，证书一键安装
x-uiyijian(){
       bash <(curl -Ls https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/x-uiyijian.sh)
}
#23闲蛋探针+中转一键搭建
xiandan(){
       bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/xiandan/xiandan.sh')
}
#24宝塔开心面板一键搭建
install_panel(){
       if [ -f /usr/bin/curl ];then curl -sSO https://io.bt.sb/install/install_latest.sh;else wget -O install_latest.sh https://io.bt.sb/install/install_latest.sh;fi;bash install_latest.sh && rm -rf install_latest.sh
}
#25流媒体检测
liumeiti(){
       bash <(curl -L -s https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/liumeiti.sh)
}
#26NPS穿透一键安装
nps(){
       bash -c "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/nps.sh)"
}
#27portainer中文版一键安装
x86(){
       bash <(curl -L -s https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/x86.sh)
}
#28L2TP一键安装
L2TP(){
      bash <(curl -s -L git.io/JPjuV)
}
#29clash订阅转换一键安装和docker2个版本
clashheji(){
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/clashheji.sh)"
}
#30x-ui安装（支持的协议：vmess、vless、trojan、shadowsocks、dokodemo-door、socks、http）
x-ui(){
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/3x-ui.sh)"
}

#31docker-青龙-elecv2p-emby-AdGuardHome-宝塔国际版-MaiARK
kiss(){
      bash <(curl -L -s https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/ql.sh)
}

#32Hysteria一键安装
Hysteria(){
      bash <(curl -fsSL https://git.io/hysteria.sh)
}

#33PVE开启直通+PVE温度硬盘显示+一键开启换源，去掉订阅
pve(){
      bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/shidahuilang/pve/main/pve.sh)"
}

#343x-ui-docker版
3x-ui-docker(){
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/refs/heads/main/sh/3x-ui-docker.sh)"
}
#35TrojanPanel支持Xray/Trojan-Go/Hysteria/NaiveProxy的多用户Web管理面板
TrojanPanel(){
      source <(curl -L https://github.com/trojanpanel/install-script/raw/main/install_script.sh)
}

#36开启ssh+BBR+root登录+密码设置
lang(){
      bash -c  "$(curl -fsSL https://raw.githubusercontent.com/shidahuilang/pve/main/lang.sh)"
}

#37世界上最简单的Trojan部署脚本
easytrojan(){
      curl https://raw.githubusercontent.com/eastmaple/easytrojan/main/easytrojan.sh -o easytrojan.sh && chmod +x easytrojan.sh && bash easytrojan.sh lang
}
#38nps-socks5服务一键搭建脚本
Scoks5(){
      wget -q -N --no-check-certificate https://raw.githubusercontent.com/wyx176/nps-socks5/master/install.sh && chmod 777 install.sh && bash install.sh
}
#39Sing-box 全家桶
sing-box(){
      bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh)
}

action=$1
if [[ "${action}" == "monitor" ]]; then
	crontab_monitor_goflyway
else
clear
cyan "╔════════════════════════════════════════════════════════════════╗"
cyan "║                                                                ║"
bold "║                    🚀 大灰狼 VPS 管理工具箱                      ║"
cyan "║                                                                ║"
cyan "║                    小鸡一键管理 · 简单高效                       ║"
cyan "║                                                                ║"
cyan "╚════════════════════════════════════════════════════════════════╝"
echo ""
blue "📖 使用教程: https://github.com/shidahuilang/SS-SSR-TG-iptables-bt"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  系统工具                                                        │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 0.  升级脚本"
green " 1.  加速系列: BBR系列、锐速"
green " 2.  一键提升VPS速度"
green " 3.  Cloudflare WARP 一键配置"
green " 4.  一键设置交换虚拟分区"
green " 5.  VPS一键3网测速脚本"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  代理工具                                                        │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 6.  安装 SS"
green " 7.  安装 SSR 脚本 (ARM)"
green " 8.  安装 V2Ray 233一键"
green " 9.  MTG 专用代理"
green " 10. MTG 专用代理 (docker版)"
green " 11. L2TP 一键安装"
green " 12. 新版 3X-UI 独立安装"
green " 13. Hysteria (歇斯底里) 一键安装"
green " 14. 3X-UI-docker版"
green " 15. Trojan Panel 多用户Web管理面板"
green " 16. 世界上最简单的Trojan部署脚本"
green " 17. NPS-Socks5 服务一键搭建"
green " 18. Sing-box 全家桶"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  面板工具                                                        │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 19. 哪吒监控探针"
green " 20. 支持多协议多用户的X-UI面板+证书一键安装"
green " 21. 闲蛋探针+中转一键搭建"
green " 22. 宝塔开心面板一键搭建"
green " 23. Portainer 可视化容器中文版"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  Docker 工具                                                     │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 24. Docker-Compose 安装"
green " 25. 一键搭建CLASH节点转换和Docker版本"
green " 26. Docker-青龙-elecv2p-emby-AdGuardHome-宝塔国际版-MaiARK"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  检测工具                                                        │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 27. 回程线路测试 (命令: ./huicheng 您的IP)"
green " 28. Netflix 解锁检测"
green " 29. CF 自动优选"
green " 30. 流媒体检测"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  穿透工具                                                        │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 31. FRP 一键内网穿刺"
green " 32. NPS 穿透一键安装"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  PVE/群晖工具                                                    │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 33. PVE开启直通+CPU硬盘温度显示+换源+去订阅+CPU睿频"
green " 34. 黑群晖CPU正确识别"
green " 35. PVE和群晖相关一键脚本"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  系统重装                                                        │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 36. 傻瓜式一键DD包 (OD源)"
green " 37. 甲骨文一键DD到Debian 11 (兼容AMD和ARM,默认密码:password)"
echo ""
cyan "┌────────────────────────────────────────────────────────────────┐"
bold "│  GCP专属工具                                                     │"
cyan "└────────────────────────────────────────────────────────────────┘"
green " 38. 开启SSH+BBR+Root登录+密码设置 (默认密码:dahuilang)"
echo ""


  
fi
echo
yellow "请输入数字 [0-38]: "
read -e -p ">> " num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	bbr_ruisu
	;;
	2)
	tools
	;;
	3)
	warp.sh
	;;
	4)
	swap
	;;
	5)
	superspeed
	;;
	6)
	ubuntu_install_ss.sh
	;;
	7)
	ssrmu
	;;
	8)
	Install_V2ray
	;;
	9)
	Tg_socks
	;;
	10)
	mtproxy
	;;
	11)
	L2TP
	;;
	12)
	x-ui
	;;
	13)
	Hysteria
	;;
	14)
	3x-ui-docker
	;;
	15)
	TrojanPanel
	;;
	16)
	easytrojan
	;;
	17)
	Scoks5
	;;
	18)
	sing-box
	;;
	19)
	nezha
	;;
	20)
	x-uiyijian
	;;
	21)
	xiandan
	;;
	22)
	install_panel
	;;
	23)
	x86
	;;
	24)
	DockerInstallation
	;;
	25)
	clashheji
	;;
	26)
	kiss
	;;
	27)
	View_huicheng
	;;
	28)
	netflix
	;;
	29)
	cf
	;;
	30)
	liumeiti
	;;
	31)
	install-frps
	;;
	32)
	nps
	;;
	33)
	pve
	;;
	34)
	ch_cpuinfo_cn
	;;
	35)
	set
	;;
	36)
	DD_OD
	;;
	37)
	DD_GD
	;;
	38)
	lang
	;;
	*)
	red "❌ 请输入正确的数字 [0-38]"
	;;
 esac

  
  
  
