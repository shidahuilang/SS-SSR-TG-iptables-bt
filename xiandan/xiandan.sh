#! /bin/bash
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

function check_sys()
{
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
    bit=$(uname -m)
        if test "$bit" != "x86_64"; then
           echo "请输入你的芯片架构，/386/armv5/armv6/armv7/armv8"
           read bit
        else bit="amd64"
    fi
}
function Installation_dependency(){
    if [[ ${release} == "centos" ]]; then
        yum -y update && yum -y upgrade
        yum install -y wget
        yum -y install lsof
        yum -y install curl
    else
        apt-get -y update && apt-get -y upgrade
        apt-get install -y wget
        apt-get install -y lsof
        apt-get -y install curl
    fi
    if ! type docker >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    systemctl start docker
    systemctl enable docker
    fi
}
function check_root()
{
    [[ $EUID != 0 ]] && echo -e "${Error} 当前非ROOT账号(或没有ROOT权限)，无法继续操作，请更换ROOT账号或使用 ${Green_background_prefix}sudo su${Font_color_suffix} 命令获取临时ROOT权限（执行后可能会提示输入当前账号的密码）。" && exit 1
}

function install(){
	num=1
    check_sys
    Installation_dependency
    rm -rf /etc/xdzz
    isInstall=1
    if [ -f /etc/xdzz/xd.mv.db ];then
        echo '已存在数据库，先帮你把数据备份至/etc/xdzz/back.xd.mv.db'
        cp -f /etc/xdzz/xd.mv.db /etc/xdzz/back.xd.mv.db
    fi
    wget -P /etc/xdzz http://sh.xdmb.xyz/xiandan/xd.mv.db
    wget -P /etc/xdzz http://sh.xdmb.xyz/xiandan/xd.trace.db
    read_port
}

function update(){
    if [[ ! -n $port ]];then
    	portinfo=`docker port xiandan | head -1`
    	if [[ ! -n "$portinfo" ]];then
    	 read_port
    	 exit 0
    	else
        	port=${portinfo#*:}
        	if [ -f /etc/xdzz/xd.mv.db ];then
                echo '先帮你把数据备份至/etc/xdzz/back.xd.mv.db'
                cp -f /etc/xdzz/xd.mv.db /etc/xdzz/back.xd.mv.db
            fi
        	update_do
    	fi
    else
        if [ -f /etc/xdzz/xd.mv.db ];then
            echo '先帮你把数据备份至/etc/xdzz/back.xd.mv.db'
            cp -f /etc/xdzz/xd.mv.db /etc/xdzz/back.xd.mv.db
        fi
        update_do
    fi
}

function checkArea (){
	echo -e "请选择面板机器所在区域（是否为国外环境）"
	echo "-----------------------------------"
	read -p "请输入(1：国外，2：国内, 默认：1): " isChina
	if [[ ! -n $isChina ]];then
		dns=8.8.8.8
	fi
	if [[ $isChina == 2 ]];then
		echo -e "您选择了国内环境，面板dns为：223.5.5.5"
		dns=223.5.5.5
	else
		echo -e "您选择了国外环境，面板dns为：8.8.8.8"
		dns=8.8.8.8
	fi
	echo $dns > /etc/xdzz/dns
}

function update_do(){
    dns=`cat /etc/xdzz/dns`
    if [[ ! -n $dns ]];then
    		checkArea
    fi
    systemctl restart docker
    version=`docker -v`
#     restartTask=`crontab -l | grep xiandan`
#     if [ "${restartTask}X" == "X" ];then
#         if ! type crontab >/dev/null 2>&1; then 
#             check_sys
#             if [[ ${release} == "centos" ]]; then
#                 yum install -y vixie-cron
#                 yum install -y crontabs
#             else
#                 apt-get install -y cron
#             fi
#             service cron start  
#         fi
# 		restartTime=3
#     	crontab -l > conf
#     	sed -i '/xiandan/d' conf
#     	echo "0 0 ${restartTime} * * ? docker restart xiandan" >> conf
#     	crontab conf
#     	rm -f conf      
#     fi
    if ! type docker >/dev/null 2>&1; then
        wget -qO- https://get.docker.com/ | sh
        systemctl start docker
    fi
    if [[ ! -n "$vNum" ]];then
        vNum='latest'
    fi
    docker rm -f xiandan
    docker pull docker.xdmb.xyz/xiandan/release:${vNum}
    echo "dns为${dns}"
    docker run --log-opt max-size=10m --dns=${dns} --log-driver json-file --restart=always --name=xiandan -v /etc/xdzz:/xiandan -p ${port}:8080 -d docker.xdmb.xyz/xiandan/release:${vNum}
    ip=`curl -4 ip.sb`
    echo -e "${Green_font_prefix}闲蛋面板已安装成功！请等待1-2分钟后访问面板入口。${Font_color_suffix}"
    echo -e "${Green_font_prefix}访问入口为 $ip:${port} ${Font_color_suffix}"
}
function uninstall(){
    rm -rf /etc/xdzz
    docker rm -f xiandan
    echo -e "${Green_font_prefix}闲蛋已成功卸载${Font_color_suffix}"
}
function start(){
	portinfo=`docker ps -a |grep xiandan`
	if [[ ! -n "$portinfo" ]];then
		echo -e "${Green_font_prefix}面板未安装,请安装面板！${Font_color_suffix}"
	else
		docker start xiandan
		echo -e "${Green_font_prefix}已启动${Font_color_suffix}"
	fi
}
function stop()
{
	portinfo=`docker ps -a |grep xiandan`
	if [[ ! -n "$portinfo" ]];then
		echo -e "${Green_font_prefix}面板未安装,请安装面板！${Font_color_suffix}"
	else
		docker stop xiandan
		echo -e "${Green_font_prefix}已停止${Font_color_suffix}"
	fi
}
function restart(){
	portinfo=`docker ps -a |grep xiandan`
	if [[ ! -n "$portinfo" ]];then
		echo -e "${Green_font_prefix}面板未安装,请安装面板！${Font_color_suffix}"
	else
		docker restart xiandan
		echo -e "${Green_font_prefix}已重启${Font_color_suffix}"
	fi
}
function restore(){
    rm -rf /etc/xdzz
	wget -P /etc/xdzz http://sh.xdmb.xyz/xiandan/xd.mv.db
    wget -P /etc/xdzz http://sh.xdmb.xyz/xiandan/xd.trace.db
    restart
}
function reset(){
    str=`docker ps | grep xiandan`
    if [[ ! -n "$str" ]];then
        echo -e "${Green_font_prefix}面板未运行${Font_color_suffix}"
        exit 0
    fi
    bash <(wget --no-check-certificate -qO- 'https://sh.xdmb.xyz/xiandan/reset.sh')
    echo -e "${Green_font_prefix}超级管理员已重置为admin / admin${Font_color_suffix}"
}
function read_port(){
	echo -e "请输入面板映射端口（面板访问端口）"
	echo "-----------------------------------"
	read -p "请输入(1-65535, 默认：80): " port
	if [[ ! -n $port ]];then
		port=80
	fi
	if [ "$port" -gt 0 ] 2>/dev/null;then
		if [[ $port -lt 0 || $port -gt 65535 ]];then
		 echo -e "端口号不正确"
		 read_port
		 exit 0
		fi
		isUsed=`lsof -i:${port}`
		if [ -n "$isUsed" ];then
		 echo -e "端口被占用"
		 read_port
		 exit 0
		fi
		update
	else
 		read_port
 		exit 0
	fi
}
function rollback() {
    echo -e "请输入特定版本号"
	echo "-----------------------------------"
	read -p "请输入一个可用的版本号: " vNum
	update
}
function autoRestart() {
    if ! type crontab >/dev/null 2>&1; then 
        echo '安装crontab';
        check_sys
        if [[ ${release} == "centos" ]]; then
            yum install -y vixie-cron
            yum install -y crontabs
        else
            apt-get install -y cron
        fi
        service cron start  
    fi
    read -p "请输入(0-23, 默认：3): " restartTime
    if [[ ! -n $restartTime ]];then
		restartTime=3
	fi
    if [[ $restartTime -lt 0 || $restartTime -gt 23 ]];then
	   echo -e "请输入正确数字"
	   exit 0
	fi
	crontab -l > conf
	sed -i '/xiandan/d' conf
	echo "0 0 ${restartTime} * * ? docker restart xiandan" >> conf
	crontab conf
	rm -f conf
	echo -e "定时任务设置成功！每天${restartTime}点重启面板"
}
function auto() {
    check_root
    echo && echo -e "${Green_font_prefix}       闲蛋面板 一键脚本
   ${Green_font_prefix} ----------- Noob_Cfy -----------
   ${Green_font_prefix}1. 安装 闲蛋面板
   ${Green_font_prefix}2. 更新 闲蛋面板
   ${Green_font_prefix}3. 卸载 闲蛋面板
  ————————————
   ${Green_font_prefix}4. 启动 闲蛋面板
   ${Green_font_prefix}5. 停止 闲蛋面板
   ${Green_font_prefix}6. 重启 闲蛋面板
  ————————————
   ${Green_font_prefix}7. 数据库还原
   ${Green_font_prefix}8. 管理员用户名密码重置
   ${Green_font_prefix}9. 安装特定版本
   ${Green_font_prefix}10. 设置自动重启
   ${Green_font_prefix}0. 退出脚本
  ———————————— ${Font_color_suffix}" && echo
  read -e -p " 请输入数字 [1-10]:" num
  case "$num" in
      1)
          install
          ;;
      2)
          update
          ;;
      3)
          uninstall
          ;;
      4)
          start
          ;;
      5)
          stop
          ;;
      6)
          restart
          ;;
      7)
          restore
          ;;
      8)
          reset
          ;;
      9)
          rollback
          ;;
      10)
          autoRestart
          ;;
      0)
		exit 0
		;;
      *)
    	echo "请输入正确数字 [1-10]"
    	;;
  esac
}

if [ $# -gt 0 ] ; then
  if [ $1 == "install" ]; then
    install
  elif [ $1 == "start" ]; then
    start
  elif [ $1 == "stop" ]; then
    stop
  elif [ $1 == "update" ]; then
    update
  elif [ $1 == "uninstall" ]; then
    uninstall
  fi
else
    auto;
fi
