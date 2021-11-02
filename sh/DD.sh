#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


sh_ver="2.0.9"




#0升级脚本
Update_Shell(){
	sh_new_ver=$(wget --no-check-certificate -qO- -t1 -T3 "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/DD.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="github"
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 无法链接到 Github !" && exit 0
	wget -N --no-check-certificate "https://raw.githubusercontent.com/veip007/hj/master/hj.sh" && chmod +x hj.sh
	echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !(注意：因为更新方式为直接覆盖当前运行的脚本，所以可能下面会提示一些报错，无视即可)" && exit 0
}
 #1安装BBR 锐速
bbr_ruisu(){
	bash <(curl -s -L https://raw.githubusercontent.com/veip007/Linux-NetSpeed/master/tcp.sh)
}
#2谷歌 BBR2 BBRV2
Google_bbr2(){
	bash <(curl -s -L https://raw.githubusercontent.com/yeyingorg/bbr2.sh/master/bbr2.sh)
}
#3安装KCPtun
Kcptun(){
	bash <(curl -s -L https://github.com/veip007/Kcptun/raw/master/kcptun/kcptun.sh)
}
#4安装SSR多用户版
Install_ssr(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/ssr.sh)
}
#5安装V2ary_233一键
Install_V2ray(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/V2Ray.sh)
}
#6安装Tg专用代理（Go版）
Tg_socks(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/mtproxy_go.sh)
}
#7安装TG专用代理（中文版）
mtproxy(){
        wget -N --no-check-certificate https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/mtproxy.sh && chmod +x mtproxy.sh && bash mtproxy.sh
}
#8安装Goflyway
Install_goflyway(){
	bash <(curl -s -L https://git.io/goflyway.sh && chmod +x goflyway.sh)
}
#9小鸡性能测试
View_superbench(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/superbench.sh)
}

#10回程线路测试
View_huicheng(){
	wget -N --no-check-certificate https://raw.githubusercontent.com/veip007/huicheng/master/huicheng && chmod +x huicheng
}
#11安装云监控
Install_status(){
	bash <(curl -s -L https://raw.githubusercontent.com/veip007/doubi/master/status.sh)
}
#12一键DD包（OD源）
DD_OD(){
	bash <(curl -s -L https://raw.githubusercontent.com/veip007/dd/master/dd-od.sh)
}
#13一键DD包（GD源）
DD_GD(){
	bash <(curl -s -L https://raw.githubusercontent.com/veip007/dd/master/dd-gd.sh)
}
#14一键开启默认bbr
open_bbr(){
	modprobe tcp_bbr && echo "tcp_bbr" | tee --append /etc/modules-load.d/modules.conf && echo "net.core.default_qdisc=fq" | tee --append /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" | tee --append /etc/sysctl.conf && sysctl -p && sysctl net.ipv4.tcp_available_congestion_control && sysctl net.ipv4.tcp_congestion_control && lsmod | grep bbr
}
#15八合一共存脚本+伪装站点
install(){
	wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}
# 16Netflix解锁检测
netflix(){
        bash <(curl -sSL "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/netflix.sh")	
}
#17xray
xray(){
bash <(curl -sSL "https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/xray.sh")	
}
#18VPS一键3网测速脚本
superspeed(){
	bash <(curl -s -L https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/superspeed.sh)
}
#19FRP内网穿刺
install-frps(){
        wget -N --no-check-certificate https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/frps/install-frps.sh -O ./install-frps.sh && chmod 700 ./install-frps.sh && bash install-frps.sh install
}
#20Docker-Compose安装
DockerInstallation(){
       bash <(curl -sSL https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/DockerInstallation.sh)
}
#21X-ui面板一键安装
install(){
       bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
}
#22闲蛋探针+中转一键搭建
xiandan(){
       bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/xiandan/xiandan.sh')
}
#23宝塔面板一键搭建
install_panel(){
       curl -sSO http://download.bt.cn/install/install_panel.sh && bash install_panel.sh
}
#24流媒体检测
liumeiti(){
       bash <(curl -L -s https://raw.githubusercontent.com/shidahuilang/SS-SSR-TG-iptables-bt/main/sh/liumeiti.sh)
}
action=$1
if [[ "${action}" == "monitor" ]]; then
	crontab_monitor_goflyway
else
echo && echo -e " 


  
+-------------------------------------------------------------+
|                        大灰狼专用                             | 
|                     小鸡一键管理脚本                          |                   
|                     一键在手小鸡无忧                          |
|                          使用教程                             |
|    https://github.com/shidahuilang/SS-SSR-TG-iptables-bt      |                     
+-------------------------------------------------------------+
 ${Green_font_prefix}0.${Font_color_suffix}  升级脚本
 ${Green_font_prefix}1.${Font_color_suffix}  加速系列：Bbr系列、锐速
 ${Green_font_prefix}2.${Font_color_suffix}  安装谷歌 BBR2 BBRV2
 ${Green_font_prefix}3.${Font_color_suffix}  安装KCPtun
 ${Green_font_prefix}4.${Font_color_suffix}  安装SSR多用户版
 ${Green_font_prefix}5.${Font_color_suffix}  安装V2ary_233一键
 ${Green_font_prefix}6.${Font_color_suffix}  TG专用代理（Go版）
 ${Green_font_prefix}7.${Font_color_suffix}  TG专用代理（中文版）
 ${Green_font_prefix}8.${Font_color_suffix}  安装Goflyway
 ${Green_font_prefix}9.${Font_color_suffix}  小鸡性能测试
 ${Green_font_prefix}10.${Font_color_suffix} 回程线路测试:命令:./huicheng 您的IP
 ${Green_font_prefix}11.${Font_color_suffix} 云监控
 ${Green_font_prefix}12.${Font_color_suffix} 傻瓜式一键DD包（OD源）
 ${Green_font_prefix}13.${Font_color_suffix} 傻瓜式一键DD包（GD源）
 ${Green_font_prefix}14.${Font_color_suffix} 一键开启默认bbr  
 ${Green_font_prefix}15.${Font_color_suffix} 八合一共存脚本+伪装站点
 ${Green_font_prefix}16.${Font_color_suffix} Netflix解锁检测
 ${Green_font_prefix}17.${Font_color_suffix} xray安装
 ${Green_font_prefix}18.${Font_color_suffix} VPS一键3网测速脚本
 ${Green_font_prefix}19.${Font_color_suffix} frp一键内网穿刺
 ${Green_font_prefix}20.${Font_color_suffix} Docker-Compose安装
 ${Green_font_prefix}21.${Font_color_suffix} 支持多协议多用户的X-ui面板
 ${Green_font_prefix}22.${Font_color_suffix} 闲蛋探针+中转一键搭建
 ${Green_font_prefix}23.${Font_color_suffix} 宝塔面板一键搭建
 ${Green_font_prefix}24.${Font_color_suffix} 流媒体检测
  " && echo
  
fi
echo
read -e -p " 请输入数字 [0-24]:" num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	bbr_ruisu
	;;
	2)
	Google_bbr2
	;;
	3)
	Kcptun
	;;
	4)
	Install_ssr
	;;
	5)
	Install_V2ray
	;;
	6)
	Tg_socks
	;;
	7)
	mtproxy
	;;
	8)
	Install_goflyway
	;;
	9)
	View_superbench
	;;
	10)
	View_huicheng
	;;
	11)
	Install_status
	;;
	12)
	DD_OD
	;;
	13)
	DD_GD
	;;
	14)
	open_bbr
	;;
	15)
	install
	;;
	16)
	netflix	
	;;
	17)
	xray	
	;;
	18)
        superspeed	
	;;
	19)
	install-frps
	;;
	20)
	DockerInstallation
	;;
	21)
	install
	;;
	22)
	xiandan
	;;
        23)
	install_panel
	;;
        24)
	liumeiti
	;;
	*)
	echo "请输入正确数字 [0-24]"
	;;
esac
  
  
  
  









