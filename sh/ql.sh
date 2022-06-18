#!/bin/bash
#author kissyouhunter

declare flag=0
clear
while [ "$flag" -eq 0 ]
do
# 青龙变量
QL_DOCKER_IMG_NAME="whyour/qinglong"
TAG="latest"
QL_PATH=""
QL_SHELL_FOLDER=$(pwd)/ql
N1_QL_FOLDER=/mnt/mmcblk2p4/ql
QL_CONTAINER_NAME=""
NETWORK="bridge"
QL_PORT="5700"
# elev2p变量
V2P_DOCKER_IMG_NAME="elecv2/elecv2p"
V2P_PATH=""
V2P_SHELL_FOLDER=$(pwd)/elecv2p
N1_V2P_FOLDER=/mnt/mmcblk2p4/elecv2p
V2P_CONTAINER_NAME=""
V2P_PORT="8100"
V2P_PORT1="8101"
V2P_PORT2="8102"
# emby变量
EMBY_DOCKER_IMG_NAME="xinjiawei1/emby_unlockd"
EMBY_TAG="latest"
EMBY_PATH=""
EMBY_CONFIG_FOLDER=$(pwd)/emby
EMBY_MOVIES_FOLDER=$(pwd)/movies
EMBY_TVSHOWS_FOLDER=$(pwd)/tvshows
EMBY_CONTAINER_NAME=""
EMBY_PORT="8096"
EMBY_PORT1="8920"
# jellyfin变量
JELLYFIN_DOCKER_IMG_NAME="jellyfin/jellyfin"
JELLYFIN_PATH=""
JELLYFIN_CONFIG_FOLDER=$(pwd)/jellyfin
JELLYFIN_MOVIES_FOLDER=$(pwd)/movies
JELLYFIN_TVSHOWS_FOLDER=$(pwd)/tvshows
JELLYFIN_CONTAINER_NAME=""
JELLYFIN_PORT="8096"
JELLYFIN_PORT1="8920"
# qbittorrent变量
QB_DOCKER_IMG_NAME="johngong/qbittorrent"
QB_TAG="qee-latest"
QB_PATH=""
QB_CONFIG_FOLDER=$(pwd)/qbittorrent
QB_DOWNLOADS_FOLDER=$(pwd)/downloads
QB_CONTAINER_NAME=""
# aria2变量
ARIA2_DOCKER_IMG_NAME="superng6/aria2"
ARIA2_TAG="webui-latest"
ARIA2_PATH=""
ARIA2_CONFIG_FOLDER=$(pwd)/aria2
ARIA2_DOWNLOADS_FOLDER=$(pwd)/downloads
ARIA2_CONTAINER_NAME=""
TOKEN="aria2"
# aria2-pro变量
ARIA2_PRO_DOCKER_IMG_NAME="p3terx/aria2-pro"
ARIA2_PRO_WEBUI_DOCKER_IMG_NAME="p3terx/ariang"
ARIA2_PRO_PATH=""
ARIA2_PRO_CONFIG_FOLDER=$(pwd)/aria2-pro
ARIA2_PRO_DOWNLOADS_FOLDER=$(pwd)/downloads
ARIA2_PRO_CONTAINER_NAME=""
# telethon变量
TG_DOCKER_IMG_NAME="kissyouhunter/telethon"
TAG="latest"
TG_PATH=""
TG_SHELL_FOLDER=$(pwd)/telethon
N1_TG_FOLDER=/mnt/mmcblk2p4/telethon
TG_CONTAINER_NAME=""
# adguardhome变量
ADG_DOCKER_IMG_NAME="adguard/adguardhome"
TAG="latest"
ADG_PATH=""
ADG_CONFIG_FOLDER=$(pwd)/adguardhome
N1_ADG_FOLDER=/mnt/mmcblk2p4/adguardhome
ADG_CONTAINER_NAME=""
# x-ui变量
XUI_DOCKER_IMG_NAME="kissyouhunter/x-ui"
TAG="latest"
DEV="dev"
XUI_PATH=""
XUI_CONFIG_FOLDER=$(pwd)/x-ui
XUI_CONTAINER_NAME=""
# aapanel变量
AAPANEL_DOCKER_IMG_NAME="aapanel/aapanel"
AAPANEL_TAG="lib"
AAPANEL_PATH=""
AAPANEL_CONFIG_FOLDER=$(pwd)/aapanel
N1_AAPANEL_FOLDER=/mnt/mmcblk2p4/aapanel
AAPANEL_CONTAINER_NAME=""
# MaiARK 变量
MAIARK_DOCKER_IMG_NAME="kissyouhunter/maiark"
MAIARK_PATH=""
MAIARK_CONFIG_FOLDER=$(pwd)/MaiARK
N1_MAIARK_FOLDER=/mnt/mmcblk2p4/MarARK
MAIARK_CONTAINER_NAME=""
MAIARK_PORT="8082"

log() {
    echo -e "\n$1"
}
inp() {
    echo -e "\n$1"
}

opt() {
    echo -n -e "输入您的选择->"
}
cancelrun() {
    if [ $# -gt 0 ]; then
        echo -e " $1 "
    fi
    exit 1
}


TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;1m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
	w) export Color="\e[29;1m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}

TIME w "============================================"
TIME w "              欢迎使用一键脚本"
TIME w "             请按照命令提示操作"
TIME r "           请保证科学上网已经开启"
TIME w "        安装过程中可以按ctrl+c强制退出"
TIME w "============================================"
#cat << EOF
TIME w "(1) 安装docker和docker-compose"
TIME w "(2) 安装<青龙>到宿主机"
TIME w "(3) 安装<elecv2p>到宿主机"
TIME w "(4) 安装docker图形管理工具"
TIME w "(5) 安装emby或jellyfin(打造自己的爱奇艺)"
TIME w "(6) 安装下载工具"
TIME w "(7) TG定时发送信息工具"
TIME w "(8) AdGuardHome DNS解析+去广告"
TIME w "(9) x-ui"
TIME w "(10) aaPanel(宝塔国际版)"
TIME w "(11) MaiARK(对接青龙提交京东CK)"
TIME r "(0) 不想安装了，给老子退出！！！"
#EOF
read -p "Please enter your choice[0-11]: " input
case $input in
#安装docker and docker-compose
1)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-3]****|"
TIME w "|******* DOCKER & DOCKER-COMPOSE ******|"
TIME w "----------------------------------------"
TIME w "(1) 安装docker和docker-comopse"
TIME w "(2) X86 openwrt安装docker和装docker-comopse"
TIME w "(3) Arm64 openwrt安装docker和装docker-comopse(例 N1 等)"
TIME b "(0) 返回上级菜单"
#EOF
TIME l "<注>openwrt宿主机默认安装dockerman图形docker管理工具！"
 read -p "Please enter your Choice[0-3]: " input1
 case $input1 in 
 1)
    TIME y " >>>>>>>>>>>开始安装docker和docker-compose"
    if [ "$lsb_dist" == "openwrt" ]; then
        TIME r "****openwrt宿主机请选择2或者3安装docker****"
    else
		sleep 1
        bash <(curl -s -S -L https://raw.githubusercontent.com/kissyouhunter/Tools/main/docker-and-docker_compose.sh)
        TIME g "****docker和docker-compose安装完成，请返回上级菜单!****"
	    sleep 5
    fi
  ;;
 2)
    TIME y " >>>>>>>>>>>开始为X86 openwrt安装docker和docker-compose"
    mkdir -p /tmp/upload/ && cd /tmp/upload/
    curl -LO https://tt.kisssik.ga/d/aliyun/files/docker-2010.12-1_x86_64.zip
    unzip docker-2010.12-1_x86_64.zip && rm -f docker-2010.12-1_x86_64.zip
    cd /tmp/upload/docker-2010.12-1_x86_64 && opkg install *.ipk && cd .. && rm -rf docker-2010.12-1_x86_64/
    docker -v && docker-compose -v
    TIME g "****docker安装完成，请返回上级菜单!****"
    sleep 5
  ;;
 3)
    TIME y " >>>>>>>>>>>开始为Arm64 openwrt安装docker和docker-compose"
    mkdir -p /tmp/upload/ && cd /tmp/upload/
    curl -LO https://tt.kisssik.ga/d/aliyun/files/docker-20.10.15-1_aarch64.zip
    unzip docker-20.10.15-1_aarch64.zip && rm -f docker-20.10.15-1_aarch64.zip
    cd /tmp/upload/docker-20.10.15-1_aarch64 && opkg install *.ipk
    cd /tmp/upload && rm -rf docker-20.10.15-1_aarch64/
    docker -v && docker-compose -v
    TIME g "****docker安装完成，请返回上级菜单!****"
    TIME g "****U盘上运行的OP，如果docker空间没有指定到 /mnt/sda4/docker ，请修改****"
    TIME g "****dockerman > 设置 > Docker 根目录 修改为 /mnt/sda4/docker ****"
    sleep 5
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装青龙
2)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|**************** 青龙 ****************|"
TIME w "----------------------------------------"
TIME w "(1) linxu系统、X86的openwrt、群辉等请选择 1"
TIME w "(2) N1的EMMC上运行的openwrt请选择 2"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>选择1或2后，如果不明白如何选择或输入，请狂按回车！"
 read -p "Please enter your choice[0-3]: " input2
 case $input2 in 
 1)
  TIME y " >>>>>>>>>>>开始安装青龙"

    input_container_ql1_info() {
    log "列出所有宿主机上的容器"
    docker ps -a
    TIME g "-----------------------------------------------------"
    TIME g "|        青龙启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|             安装完成，自动退出脚本                |"
    if [ "$NETWORK" = "host" ]; then
    		TIME g "|            访问方式为 宿主机ip:5700               |"
    elif [ "$NETWORK" = "bridge" ]; then
    		TIME g "|            访问方式为 宿主机ip:$QL_PORT               |"
    fi
    TIME g "-----------------------------------------------------"
    exit 0
    }

  # 确认
  input_container_ql1_check() {
  while true
  do
  	TIME y "青龙配置文件路径：$QL_PATH"
  	TIME y "青龙容器名：$QL_CONTAINER_NAME"
  	TIME y "青龙网络类型：$NETWORK"
    TIME y "青龙版本：$TAG"
  	if [ "$NETWORK" = "host" ]; then
  		TIME y "青龙面板端口：5700"
  	elif [ "$NETWORK" = "bridge" ]; then
  		TIME y "青龙网络请求查看端口：$QL_PORT"
  	fi
  	read -r -p "以上信息是否正确？[Y/n] " input21
  	case $input21 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			QL_PORT="5700"
            TAG="latest"
  			input_container_ql1_version
            input_container_ql1_judge
            input_container_ql1_info
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done
  }

  # 版本号
  input_container_ql1_version() {
  TIME w "青龙自2.12.0开始改变了目录结构，本脚本开始提供不同青龙版本。"
  TIME w "请根据提示驶入对应内容。"
  TIME w "目前提供的版本有如下："
  TIME w "2.10、2.10.6、2.10.7、2.10.8、2.10.9、2.10.10、2.10.11、2.10.12、2.10.13"
  TIME w "2.11.0、2.11.1、2.11.2.2.11.3"
  TIME w "2.12.0、2.12.1、2.12.2"
  TIME w "2.13.0、2.13.1、2.13.2和最新"
  echo -n -e "请输入版本号（回车默认为最新版本）: "
  read ql_version
  if [ -z "$ql_version" ]; then
      QL_VERSION=$TAG
  elif [ -n "$ql_version" ]; then
      QL_VERSION=$ql_version
  fi
  TAG=$QL_VERSION
  }
  input_container_ql1_version

  # 创建映射文件夹
  input_container_ql1_config1() {
  echo -n -e "请输入青龙配置文件保存的绝对路径（示例：/home/ql)，回车默认为当前目录: "
  read ql_path
  if [ -z "$ql_path" ]; then
      QL_PATH=$QL_SHELL_FOLDER
  elif [ -d "$ql_path" ]; then
      QL_PATH=$ql_path
  else
      #mkdir -p $ql_path
      QL_PATH=$ql_path
  fi
  CONFIG_PATH=$QL_PATH
  }

  # 创建映射文件夹
  input_container_ql1_config2() {
  echo -n -e "请输入青龙配置文件保存的绝对路径（示例：/home/ql)，回车默认为当前目录: "
  read ql_path
  if [ -z "$ql_path" ]; then
      QL_PATH=$QL_SHELL_FOLDER
  elif [ -d "$ql_path" ]; then
      QL_PATH=$ql_path
  else
      #mkdir -p $ql_path
      QL_PATH=$ql_path
  fi
  CONFIG_PATH=$QL_PATH/config
  DB_PATH=$QL_PATH/db
  REPO_PATH=$QL_PATH/repo
  SCRIPT_PATH=$QL_PATH/scripts
  LOG_PATH=$QL_PATH/log
  DEPS_PATH=$QL_PATH/deps
  }

  # 输入容器名
  input_container_ql1_name() {
    echo -n -e "请输入将要创建的容器名[默认为：ql]-> "
    read container_name
    if [ -z "$container_name" ]; then
        QL_CONTAINER_NAME="ql"
    else
        QL_CONTAINER_NAME=$container_name
    fi
  }

  # 网络模式
  input_container_ql1_network_config() {
  inp "请选择容器的网络类型：\n1) host\n2) bridge[默认]"
  opt
  read net
  if [ "$net" = "1" ]; then
      NETWORK="host"
      MAPPING_QL_PORT=""
  fi
  
  if [ "$NETWORK" = "bridge" ]; then
      inp "是否修改青龙端口[默认 5700]：\n1) 修改\n2) 不修改[默认]"
      opt
      read change_ql_port
      if [ "$change_ql_port" = "1" ]; then
          echo -n -e "输入想修改的端口->"
          read QL_PORT
      else
          QL_PORT="5700"
      fi
  fi
  }

  input_container_ql1_build1() {
  TIME y " >>>>>>>>>>>配置完成，开始安装青龙"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/ql/data \
      -e ENABLE_HANGUP=false \
      -e ENABLE_WEB_PANEL=true \
      -p $QL_PORT:5700 \
      --name $QL_CONTAINER_NAME \
      --hostname $QL_CONTAINER_NAME \
      --restart always \
      --network $NETWORK \
      $QL_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi
  }

  input_container_ql1_build2() {
  TIME y " >>>>>>>>>>>配置完成，开始安装青龙"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $DB_PATH $REPO_PATH $SCRIPT_PATH $LOG_PATH $DEPS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/ql/config \
      -v $DB_PATH:/ql/db \
      -v $LOG_PATH:/ql/log \
      -v $REPO_PATH:/ql/repo \
      -v $SCRIPT_PATH:/ql/scripts \
      -v $DEPS_PATH:/ql/deps \
      -e ENABLE_HANGUP=false \
      -e ENABLE_WEB_PANEL=true \
      -p $QL_PORT:5700 \
      --name $QL_CONTAINER_NAME \
      --hostname $QL_CONTAINER_NAME \
      --restart always \
      --network $NETWORK \
      $QL_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi
  }

  input_container_ql1_judge() {
  if [ $TAG == latest ] || [ $TAG == "2.12" ] || [ $TAG == "2.12.0" ] || [ $TAG == "2.12.1" ] || [ $TAG == "2.12.2" ] || [ $TAG == "2.13" ] || [ $TAG == "2.13.0" ] || [ $TAG == "2.13.1" ]; then
      input_container_ql1_config1
      input_container_ql1_name
      input_container_ql1_network_config
      input_container_ql1_check
      input_container_ql1_build1
  else 
      input_container_ql1_config2
      input_container_ql1_name
      input_container_ql1_network_config
      input_container_ql1_check
      input_container_ql1_build2
  fi
  }
  input_container_ql1_judge

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------"
    TIME g "|        青龙启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|             安装完成，自动退出脚本                |"
    if [ "$NETWORK" = "host" ]; then
    		TIME g "|            访问方式为 宿主机ip:5700               |"
    elif [ "$NETWORK" = "bridge" ]; then
    		TIME g "|            访问方式为 宿主机ip:$QL_PORT               |"
    fi
    TIME g "-----------------------------------------------------"
  exit 0
  ;;
 2)  
  TIME y " >>>>>>>>>>>开始安装青龙到N1的/mnt/mmcblk2p4/"

    input_container_ql2_info() {
    log "列出所有宿主机上的容器"
    docker ps -a
    TIME g "-----------------------------------------------------"
    TIME g "|        青龙启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|             安装完成，自动退出脚本                |"
    if [ "$NETWORK" = "host" ]; then
    		TIME g "|            访问方式为 宿主机ip:5700               |"
    elif [ "$NETWORK" = "bridge" ]; then
    		TIME g "|            访问方式为 宿主机ip:$QL_PORT               |"
    fi
    TIME g "-----------------------------------------------------"
    exit 0
    }

  # 确认
  input_container_ql2_check() {
  while true
  do
  	TIME y "青龙配置文件路径：$QL_PATH"
  	TIME y "青龙容器名：$QL_CONTAINER_NAME"
  	TIME y "青龙网络类型：$NETWORK"
    TIME y "青龙版本：$TAG"
  	if [ "$NETWORK" = "host" ]; then
  		TIME y "青龙面板端口：5700"
  	elif [ "$NETWORK" = "bridge" ]; then
  		TIME y "青龙网络请求查看端口：$QL_PORT"
  	fi
  	read -r -p "以上信息是否正确？[Y/n] " input21
  	case $input21 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			QL_PORT="5700"
            TAG="latest"
  			input_container_ql2_version
            input_container_ql2_judge
            input_container_ql2_info
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done
  }

  # 版本号
  input_container_ql2_version() {
  TIME w "青龙自2.12.0开始改变了目录结构，本脚本开始提供不同青龙版本。"
  TIME w "请根据提示驶入对应内容。"
  TIME w "目前提供的版本有如下："
  TIME w "2.10、2.10.6、2.10.7、2.10.8、2.10.9、2.10.10、2.10.11、2.10.12、2.10.13"
  TIME w "2.11.0、2.11.1、2.11.2.2.11.3"
  TIME w "2.12.0、2.12.1、2.12.2"
  TIME w "2.13.0、2.13.1、2.13.2和最新"
  echo -n -e "请输入版本号（回车默认为最新版本）: "
  read ql_version
  if [ -z "$ql_version" ]; then
      QL_VERSION=$TAG
  elif [ -n "$ql_version" ]; then
      QL_VERSION=$ql_version
  fi
  TAG=$QL_VERSION
  }
  input_container_ql2_version


  # 创建映射文件夹
  input_container_ql2_config1() {
  echo -n -e "请输入青龙存储的文件夹名称（如：ql)，回车默认为 ql: "
  read ql_path
  if [ -z "$ql_path" ]; then
      QL_PATH=$N1_QL_FOLDER
  elif [ -d "$ql_path" ]; then
      QL_PATH=/mnt/mmcblk2p4/$ql_path
  else
      #mkdir -p /mnt/mmcblk2p4/$ql_path
      QL_PATH=/mnt/mmcblk2p4/$ql_path
  fi
  CONFIG_PATH=$QL_PATH
  }

  # 创建映射文件夹
  input_container_ql2_config2() {
  echo -n -e "请输入青龙存储的文件夹名称（如：ql)，回车默认为 ql: "
  read ql_path
  if [ -z "$ql_path" ]; then
      QL_PATH=$N1_QL_FOLDER
  elif [ -d "$ql_path" ]; then
      QL_PATH=/mnt/mmcblk2p4/$ql_path
  else
      #mkdir -p /mnt/mmcblk2p4/$ql_path
      QL_PATH=/mnt/mmcblk2p4/$ql_path
  fi
  CONFIG_PATH=$QL_PATH/config
  DB_PATH=$QL_PATH/db
  REPO_PATH=$QL_PATH/repo
  SCRIPT_PATH=$QL_PATH/scripts
  LOG_PATH=$QL_PATH/log
  DEPS_PATH=$QL_PATH/deps
  }
  
  # 输入容器名
  input_container_ql2_name() {
    echo -n -e "请输入将要创建的容器名[默认为：ql]-> "
    read container_name
    if [ -z "$container_name" ]; then
        QL_CONTAINER_NAME="ql"
    else
        QL_CONTAINER_NAME=$container_name
    fi
  }

  # 网络模式
  input_container_ql2_network_config() {
  inp "请选择容器的网络类型：\n1) host\n2) bridge[默认]"
  opt
  read net
  if [ "$net" = "1" ]; then
      NETWORK="host"
      MAPPING_QL_PORT=""
  fi
  
  if [ "$NETWORK" = "bridge" ]; then
      inp "是否修改青龙端口[默认 5700]：\n1) 修改\n2) 不修改[默认]"
      opt
      read change_ql_port
      if [ "$change_ql_port" = "1" ]; then
          echo -n -e "输入想修改的端口->"
          read QL_PORT
      else
          QL_PORT="5700"
      fi
  fi
  }

  input_container_ql2_build1() {
  TIME y " >>>>>>>>>>>配置完成，开始安装青龙"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $DB_PATH $REPO_PATH $SCRIPT_PATH $LOG_PATH $DEPS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "3.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/ql/data \
      -e ENABLE_HANGUP=false \
      -e ENABLE_WEB_PANEL=true \
      -p $QL_PORT:5700 \
      --name $QL_CONTAINER_NAME \
      --hostname $QL_CONTAINER_NAME \
      --restart always \
      --network $NETWORK \
      $QL_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi
  }

  input_container_ql2_build2() {
  TIME y " >>>>>>>>>>>配置完成，开始安装青龙"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $DB_PATH $REPO_PATH $SCRIPT_PATH $LOG_PATH $DEPS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "3.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/ql/config \
      -v $DB_PATH:/ql/db \
      -v $LOG_PATH:/ql/log \
      -v $REPO_PATH:/ql/repo \
      -v $SCRIPT_PATH:/ql/scripts \
      -v $DEPS_PATH:/ql/deps \
      -e ENABLE_HANGUP=false \
      -e ENABLE_WEB_PANEL=true \
      -p $QL_PORT:5700 \
      --name $QL_CONTAINER_NAME \
      --hostname $QL_CONTAINER_NAME \
      --restart always \
      --network $NETWORK \
      $QL_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi
  }

  input_container_ql2_judge() {
  if [ $TAG == latest ]; then
      input_container_ql2_config1
      input_container_ql2_name
      input_container_ql2_network_config
      input_container_ql2_check
      input_container_ql2_build1
  else 
      input_container_ql2_config2
      input_container_ql2_name
      input_container_ql2_network_config
      input_container_ql2_check
      input_container_ql2_build2
  fi
  }
  input_container_ql2_judge

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------"
    TIME g "|        青龙启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|             安装完成，自动退出脚本                |"
    if [ "$NETWORK" = "host" ]; then
    		TIME g "|            访问方式为 宿主机ip:5700               |"
    elif [ "$NETWORK" = "bridge" ]; then
    		TIME g "|            访问方式为 宿主机ip:$QL_PORT               |"
    fi
    TIME g "-----------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装elecv2p
3)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|*************** ELECV2P **************|"
TIME w "----------------------------------------"
TIME w "(1) linxu系统、X86的openwrt、群辉等请选择 1"
TIME w "(2) N1的EMMC上运行的openwrt请选择 2"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>选择1或2后，如果不明白如何选择或输入，请狂按回车！"
 read -p "Please enter your Choice[0-2]: " input3
 case $input3 in 
 1)
  TIME y " >>>>>>>>>>>开始安装elecv2p"
  # 创建映射文件夹
  input_container_v2p1_config() {
  echo -n -e "请输入elecv2p配置文件保存的绝对路径（示例：/home/elecv2p)，回车默认为当前目录: "
  read v2p_path
  if [ -z "$v2p_path" ]; then
      V2P_PATH=$V2P_SHELL_FOLDER
  elif [ -d "$v2p_path" ]; then
      V2P_PATH=$v2p_path
  else
      #mkdir -p $v2p_path
      V2P_PATH=$v2p_path
  fi
  JSFILE_PATH=$V2P_PATH/JSFile
  LISTS_PATH=$V2P_PATH/Lists
  STORE_PATH=$V2P_PATH/Store
  SHELL_PATH=$V2P_PATH/Shell
  ROOTCA_PATH=$V2P_PATH/rootCA
  EFSS_PATH=$V2P_PATH/efss
  LOG_PATH=$V2P_PATH/logs
  }
  input_container_v2p1_config
  
  # 输入容器名
  input_container_v2p1_name() {
    echo -n -e "请输入将要创建的容器名[默认为：elecv2p]-> "
    read container_name
    if [ -z "$container_name" ]; then
        V2P_CONTAINER_NAME="elecv2p"
    else
        V2P_CONTAINER_NAME=$container_name
    fi
  }
  input_container_v2p1_name

  # 面板端口
  input_container_v2p1_webui_config() {
  inp "是否修改elecv2p面板端口[默认 8100]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_v2p_port
  if [ "$change_v2p_port" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read V2P_PORT
  fi
  }
  input_container_v2p1_webui_config
  
  # ANYPROXY端口
  input_container_v2p1_anyproxy_config() {
  inp "是否修改elecv2p的anyproxy端口[默认 8101]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_v2p_port1
  if [ "$change_v2p_port1" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read V2P_PORT1
  fi
  }
  input_container_v2p1_anyproxy_config
  
  # 网络请求查看端口
  input_container_v2p1_http_config() {
  inp "是否修改elecv2p网络请求查看端口[默认 8102]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_v2p_port2
  if [ "$change_v2p_port2" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read V2P_PORT2
  fi
  }
  input_container_v2p1_http_config

  # 确认
  while true
  do
  	TIME y "elecv2p 配置文件路径：$V2P_PATH"
  	TIME y "elecv2p 容器名：$V2P_CONTAINER_NAME"
  	TIME y "elecv2p 面板端口：$V2P_PORT"
  	TIME y "elecv2p anyproxy端口：$V2P_PORT1"
  	TIME y "elecv2p 网络请求查看端口：$V2P_PORT2"
  	read -r -p "以上信息是否正确？[Y/n] " input32
  	case $input32 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			V2P_PORT="8100"
  			V2P_PORT1="8101"
  			V2P_PORT2="8102"
  			input_container_v2p1_config
  			input_container_v2p1_name
  			input_container_v2p1_webui_config
  			input_container_v2p1_anyproxy_config
  			input_container_v2p1_http_config
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装elecv2p"
  log "1.开始创建配置文件目录"
  PATH_LIST=($JSFILE_PATH $LISTS_PATH $STORE_PATH $SHELL_PATH $ROOTCA_PATH $EFSS_PATH $LOG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -v $JSFILE_PATH:/usr/local/app/script/JSFile \
      -v $LISTS_PATH:/usr/local/app/script/Lists \
      -v $STORE_PATH:/usr/local/app/script/Store \
      -v $SHELL_PATH:/usr/local/app/script/Shell \
      -v $ROOTCA_PATH:/usr/local/app/rootCA \
      -v $EFSS_PATH:/usr/local/app/efss \
      -v $LOG_PATH:/usr/local/app/logs \
      -p $V2P_PORT:80 -p $V2P_PORT1:8001 -p $V2P_PORT2:8002 \
      -e TZ=Asia/Shanghai \
      --name $V2P_CONTAINER_NAME \
      --hostname $V2P_CONTAINER_NAME \
      --restart always \
      $V2P_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------"
    TIME g "|      elev2p启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|             安装完成，自动退出脚本                |"
    TIME g "|            访问方式为 宿主机ip:$V2P_PORT               |"
    TIME g "-----------------------------------------------------"
  exit 0
  ;;
 2)
  TIME y " >>>>>>>>>>>开始安装elecv2p到N1的/mnt/mmcblk2p4/"
  # 创建映射文件夹
  input_container_v2p2_config() {
  echo -n -e "请输入elecv2p存储的文件夹名称（如：elecv2p)，回车默认为 elecv2p: "
  read v2p_path
  if [ -z "$v2p_path" ]; then
      V2P_PATH=$N1_V2P_FOLDER
  elif [ -d "$v2p_path" ]; then
      V2P_PATH=/mnt/mmcblk2p4/$v2p_path
  else
      #mkdir -p /mnt/mmcblk2p4/$v2p_path
      V2P_PATH=/mnt/mmcblk2p4/$v2p_path
  fi
  JSFILE_PATH=$V2P_PATH/JSFile
  LISTS_PATH=$V2P_PATH/Lists
  STORE_PATH=$V2P_PATH/Store
  SHELL_PATH=$V2P_PATH/Shell
  ROOTCA_PATH=$V2P_PATH/rootCA
  EFSS_PATH=$V2P_PATH/efss
  LOG_PATH=$V2P_PATH/logs
  }
  input_container_v2p2_config
  
  # 输入容器名
  input_container_v2p2_name() {
    echo -n -e "请输入将要创建的容器名[默认为：elecv2p]-> "
    read container_name
    if [ -z "$container_name" ]; then
        V2P_CONTAINER_NAME="elecv2p"
    else
        V2P_CONTAINER_NAME=$container_name
    fi
  }
  input_container_v2p2_name

  # 面板端口
  input_container_v2p2_webui_config() {
  inp "是否修改elecv2p面板端口[默认 8100]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_v2p_port
  if [ "$change_v2p_port" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read V2P_PORT
  fi
  }
  input_container_v2p2_webui_config
  
  # ANYPROXY端口
  input_container_v2p2_anyproxy_config() {
  inp "是否修改elecv2p的anyproxy端口[默认 8101]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_v2p_port1
  if [ "$change_v2p_port1" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read V2P_PORT1
  fi
  }
  input_container_v2p2_anyproxy_config
  
  # 网络请求查看端口
  input_container_v2p2_http_config() {
  inp "是否修改elecv2p网络请求查看端口[默认 8102]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_v2p_port2
  if [ "$change_v2p_port2" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read V2P_PORT2
  fi
  }
  input_container_v2p2_http_config

  # 确认
  while true
  do
  	TIME y "elecv2p 配置文件路径：$V2P_PATH"
  	TIME y "elecv2p 容器名：$V2P_CONTAINER_NAME"
  	TIME y "elecv2p 面板端口：$V2P_PORT"
  	TIME y "elecv2p anyproxy端口：$V2P_PORT1"
  	TIME y "elecv2p 网络请求查看端口：$V2P_PORT2"
  	read -r -p "以上信息是否正确？[Y/n] " input32
  	case $input32 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			V2P_PORT="8100"
  			V2P_PORT1="8101"
  			V2P_PORT2="8102"
  			input_container_v2p2_config
  			input_container_v2p2_name
  			input_container_v2p2_webui_config
  			input_container_v2p2_anyproxy_config
  			input_container_v2p2_http_config
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装elecv2p"
  log "1.开始创建配置文件目录"
  PATH_LIST=($JSFILE_PATH $LISTS_PATH $STORE_PATH $SHELL_PATH $ROOTCA_PATH $EFSS_PATH $LOG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -v $JSFILE_PATH:/usr/local/app/script/JSFile \
      -v $LISTS_PATH:/usr/local/app/script/Lists \
      -v $STORE_PATH:/usr/local/app/script/Store \
      -v $SHELL_PATH:/usr/local/app/script/Shell \
      -v $ROOTCA_PATH:/usr/local/app/rootCA \
      -v $EFSS_PATH:/usr/local/app/efss \
      -v $LOG_PATH:/usr/local/app/logs \
      -p $V2P_PORT:80 -p $V2P_PORT1:8001 -p $V2P_PORT2:8002 \
      -e TZ=Asia/Shanghai \
      --name $V2P_CONTAINER_NAME \
      --hostname $V2P_CONTAINER_NAME \
      --restart always \
      $V2P_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------"
    TIME g "|      elev2p启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|             安装完成，自动退出脚本                |"
    TIME g "|            访问方式为 宿主机ip:$V2P_PORT               |"
    TIME g "-----------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装portainer
4)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|********** PORTAINER & YACHT *********|"
TIME w "----------------------------------------"
TIME w "(1) 安装portianer"
TIME w "(2) 安装yacht"
TIME w "(3) 安装simpledocker 中文"
TIME b "(0) 返回上级菜单"
#EOF
 read -p "Please enter your Choice[0-2]: " input4
 case $input4 in 
 1)
    TIME y " >>>>>>>>>>>开始安装portainer"
    docker volume create portainer_data
    docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
    
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
    fi

    TIME g "------------------------------------------------------"
    TIME g "|      portainer启动需要一点点时间，请耐心等待！     |"
    sleep 10
    TIME g "|              安装完成，自动退出脚本                |"
    TIME g "|   访问方式为宿主机ip:端口(例192.168.2.1:9000)      |"
    TIME g "------------------------------------------------------"
  exit 0  
  ;;
 2)
    TIME y " >>>>>>>>>>>开始安装yacht"
    docker volume create yacht
    docker run -d -p 8008:8000 --name=yacht --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v yacht:/config selfhostedpro/yacht    
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
    fi

    TIME g "------------------------------------------------------"
    TIME g "|         yacht启动需要一点点时间，请耐心等待！      |"
    sleep 10
    TIME g "|              安装完成，自动退出脚本                |"
    TIME g "|       默认账号：admin@yacht.local 密码：pass       |"
    TIME g "|     访问方式为宿主机ip:端口(例192.168.2.1:8008)    |"
    TIME g "------------------------------------------------------"
  exit 0  
  ;;
 3)
    TIME y " >>>>>>>>>>>开始安装simpledocker"
    cd /tmp && curl -Lo docker-compose.yml https://raw.githubusercontent.com/kissyouhunter/Tools/main/simpledocker-docker-compose.yml
    docker-compose up -d    
    if [ $? -ne 0 ] ; then
        cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
    fi

    TIME g "------------------------------------------------------"
    TIME g "|     simpledocker启动需要一点点时间，请耐心等待！   |"
    sleep 10
    TIME g "|              安装完成，自动退出脚本                |"
    TIME g "|           默认账号：admin 密码：123456             |"
    TIME g "|     访问方式为宿主机ip:端口(例192.168.2.1:9009)    |"
    TIME g "------------------------------------------------------"
  exit 0  
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装emby和jellyfin
5)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|*********** EMBY & JELLYFIN **********|"
TIME w "----------------------------------------"
TIME w "(1) 安装emby (开心版暂无arm64)"
TIME w "(2) 安装jellyfin"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>请使用root账户部署容器"
 read -p "Please enter your Choice[0-2]: " input5
 case $input5 in 
 1)
    TIME y " >>>>>>>>>>>开始安装emby"
  # 创建映射文件夹
  input_container_emby_config() {
  echo -n -e "请输入emby配置文件保存的绝对路径（示例：/home/emby)，回车默认为当前目录: "
  read emby_path
  if [ -z "$emby_path" ]; then
      EMBY_PATH=$EMBY_CONFIG_FOLDER
  elif [ -d "$emby_path" ]; then
      EMBY_PATH=$emby_path
  else
      #mkdir -p $emby_path
      EMBY_PATH=$emby_path
  fi
  CONFIG_PATH=$EMBY_PATH/config
  echo -n -e "请输入电影文件保存的绝对路径（示例：/home/movies)，回车默认为当前目录: "
  read movies_path
  if [ -z "$movies_path" ]; then
      MOVIES_PATH=$EMBY_MOVIES_FOLDER
  elif [ -d "$movies_path" ]; then
      MOVIES_PATH=$movies_path
  else
      #mkdir -p $movies_path
      MOVIES_PATH=$movies_path
  fi
  echo -n -e "请输入电视剧文件保存的绝对路径（示例：/home/tvshows)，回车默认为当前目录: "
  read tvshows_path
  if [ -z "$tvshows_path" ]; then
      TVSHOWS_PATH=$EMBY_TVSHOWS_FOLDER
  elif [ -d "$tvshows_path" ]; then
      TVSHOWS_PATH=$tvshows_path
  else
      #mkdir -p $tvshows_path
      TVSHOWS_PATH=$tvshows_path
  fi
  }
  input_container_emby_config
  
  # 输入容器名
  input_container_emby_name() {
    echo -n -e "请输入将要创建的容器名[默认为：emby]-> "
    read container_name
    if [ -z "$container_name" ]; then
        EMBY_CONTAINER_NAME="emby"
    else
        EMBY_CONTAINER_NAME=$container_name
    fi
  }
  input_container_emby_name

  # 面板端口
  input_container_emby_webui_config() {
  inp "是否修改emby面板端口[默认 8096]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_emby_port
  if [ "$change_emby_port" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read EMBY_PORT
  fi
  }
  input_container_emby_webui_config
  
  # https端口
  input_container_emby_https_config() {
  inp "是否修改emby的https端口[默认 8920]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_emby_port1
  if [ "$change_emby_port1" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read EMBY_PORT1
  fi
  }
  input_container_emby_https_config

  # 确认
  while true
  do
  	TIME y "emby 配置文件路径：$CONFIG_PATH"
  	TIME y "emby 电影文件路径：$MOVIES_PATH"
  	TIME y "emby 电视剧文件路径：$TVSHOWS_PATH"
  	TIME y "emby 容器名：$EMBY_CONTAINER_NAME"
  	TIME y "emby 面板端口：$EMBY_PORT"
  	TIME y "emby https端口：$EMBY_PORT1"
  	read -r -p "以上信息是否正确？[Y/n] " input51
  	case $input51 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			EMBY_PORT="8096"
  			EMBY_PORT1="8920"
  			input_container_emby_config
  			input_container_emby_name
  			input_container_emby_webui_config
  			input_container_emby_https_config
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装emby"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $MOVIES_PATH $TVSHOWS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
      if [ -d "/dev/dri" ]; then
          docker run -dit \
              --name $EMBY_CONTAINER_NAME \
              --hostname $EMBY_CONTAINER_NAME \
              --restart always \
              -v $CONFIG_PATH:/config \
              -v $MOVIES_PATH:/mnt/movies \
              -v $TVSHOWS_PATH:/mnt/tvshows \
              -p $EMBY_PORT:8096 -p $EMBY_PORT1:8920 \
              -e TZ=Asia/Shanghai \
              --device /dev/dri:/dev/dri \
              -e UMASK_SET=022 \
              -e UID=0 \
              -e GID=0 \
              -e GIDLIST=0 \
              $EMBY_DOCKER_IMG_NAME:$EMBY_TAG
      else
          docker run -dit \
              --name $EMBY_CONTAINER_NAME \
              --hostname $EMBY_CONTAINER_NAME \
              --restart always \
              -v $CONFIG_PATH:/config \
              -v $MOVIES_PATH:/mnt/movies \
              -v $TVSHOWS_PATH:/mnt/tvshows \
              -p $EMBY_PORT:8096 -p $EMBY_PORT1:8920 \
              -e TZ=Asia/Shanghai \
              -e UMASK_SET=022 \
              -e UID=0 \
              -e GID=0 \
              -e GIDLIST=0 \
              $EMBY_DOCKER_IMG_NAME:$EMBY_TAG
      fi
      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------------"
    TIME g "|              emby启动需要一点点时间，请耐心等待！             |"
    sleep 10
    TIME g "|                    安装完成，自动退出脚本                     |"
    TIME g "|         emby默认端口为8096，如有修改请访问修改的端口          |"
    TIME g "|         访问方式为宿主机ip:端口(例192.168.2.1:8096)           |"
    TIME g "|   openwrt需要先执行命令 chmod 777 /dev/dri/* 才能读取到显卡   |"
    TIME g "-----------------------------------------------------------------"
  exit 0
  ;;
 2)
    TIME y " >>>>>>>>>>>开始安装jellyfin"
  # 创建映射文件夹
  input_container_jellyfin_config() {
  echo -n -e "请输入jellyfin配置文件保存的绝对路径（示例：/home/jellyfin)，回车默认为当前目录: "
  read jellyfin_path
  if [ -z "$jellyfin_path" ]; then
      JELLYFIN_PATH=$JELLYFIN_CONFIG_FOLDER
  elif [ -d "$jellyfin_path" ]; then
      JELLYFIN_PATH=$jellyfin_path
  else
      #mkdir -p $jellyfin_path
      JELLYFIN_PATH=$jellyfin_path
  fi
  CONFIG_PATH=$JELLYFIN_PATH/config
  echo -n -e "请输入电影文件保存的绝对路径（示例：/home/movies)，回车默认为当前目录: "
  read movies_path
  if [ -z "$movies_path" ]; then
      MOVIES_PATH=$JELLYFIN_MOVIES_FOLDER
  elif [ -d "$movies_path" ]; then
      MOVIES_PATH=$movies_path
  else
      #mkdir -p $movies_path
      MOVIES_PATH=$movies_path
  fi
  echo -n -e "请输入电视剧文件保存的绝对路径（示例：/home/tvshows)，回车默认为当前目录: "
  read tvshows_path
  if [ -z "$tvshows_path" ]; then
      TVSHOWS_PATH=$JELLYFIN_TVSHOWS_FOLDER
  elif [ -d "$tvshows_path" ]; then
      TVSHOWS_PATH=$tvshows_path
  else
      #mkdir -p $tvshows_path
      TVSHOWS_PATH=$tvshows_path
  fi
  }
  input_container_jellyfin_config
  
  # 输入容器名
  input_container_jellyfin_name() {
    echo -n -e "请输入将要创建的容器名[默认为：jellyfin]-> "
    read container_name
    if [ -z "$container_name" ]; then
        JELLYFIN_CONTAINER_NAME="jellyfin"
    else
        JELLYFIN_CONTAINER_NAME=$container_name
    fi
  }
  input_container_jellyfin_name

  # 面板端口
  input_container_jellyfin_webui_config() {
  inp "是否修改jellyfin面板端口[默认 8096]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_jellyfin_port
  if [ "$change_jellyfin_port" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read JELLYFIN_PORT
  fi
  }
  input_container_jellyfin_webui_config
  
  # https端口
  input_container_jellyfin_https_config() {
  inp "是否修改jellyfin的https端口[默认 8920]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_jellyfin_port1
  if [ "$change_jellyfin_port1" = "1" ]; then
      echo -n -e "输入想修改的端口->"
      read JELLYFIN_PORT1
  fi
  }
  input_container_jellyfin_https_config

  # 确认
  while true
  do
  	TIME y "jellyfin 配置文件路径：$CONFIG_PATH"
  	TIME y "jellyfin 电影文件路径：$MOVIES_PATH"
  	TIME y "jellyfin 电视剧文件路径：$TVSHOWS_PATH"
  	TIME y "jellyfin 容器名：$JELLYFIN_CONTAINER_NAME"
  	TIME y "jellyfin 面板端口：$JELLYFIN_PORT"
  	TIME y "jellyfin https端口：$JELLYFIN_PORT1"
  	read -r -p "以上信息是否正确？[Y/n] " input52
  	case $input52 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			JELLYFIN_PORT="8096"
  			JELLYFIN_PORT1="8920"
  			input_container_jellyfin_config
  			input_container_jellyfin_name
  			input_container_jellyfin_webui_config
  			input_container_jellyfin_https_config
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装jellyfin"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $MOVIES_PATH $TVSHOWS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
      if [ -d "/dev/dri" ]; then
          docker run -dit \
              --name $JELLYFIN_CONTAINER_NAME \
              --hostname $JELLYFIN_CONTAINER_NAME \
              --restart always \
              -v $CONFIG_PATH:/config \
              -v $MOVIES_PATH:/mnt/movies \
              -v $TVSHOWS_PATH:/mnt/tvshows \
              -p $JELLYFIN_PORT:8096 -p $JELLYFIN_PORT1:8920 \
              -e TZ=Asia/Shanghai \
              --device /dev/dri:/dev/dri \
              -e UMASK_SET=022 \
              -e UID=0 \
              -e GID=0 \
              -e GIDLIST=0 \
              $JELLYFIN_DOCKER_IMG_NAME:$TAG
      else
          docker run -dit \
              --name $JELLYFIN_CONTAINER_NAME \
              --hostname $JELLYFIN_CONTAINER_NAME \
              --restart always \
              -v $CONFIG_PATH:/config \
              -v $MOVIES_PATH:/mnt/movies \
              -v $TVSHOWS_PATH:/mnt/tvshows \
              -p $JELLYFIN_PORT:8096 -p $JELLYFIN_PORT1:8920 \
              -e TZ=Asia/Shanghai \
              -e UMASK_SET=022 \
              -e UID=0 \
              -e GID=0 \
              -e GIDLIST=0 \
              $JELLYFIN_DOCKER_IMG_NAME:$TAG
      fi
      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------------"
    TIME g "|              emby启动需要一点点时间，请耐心等待！             |"
    sleep 10
    TIME g "|                    安装完成，自动退出脚本                     |"
    TIME g "|       jellyfin默认端口为8096，如有修改请访问修改的端口        |"
    TIME g "|         访问方式为宿主机ip:端口(例192.168.2.1:8096)           |"
    TIME g "|   openwrt需要先执行命令 chmod 777 /dev/dri/* 才能读取到显卡   |"
    TIME g "-----------------------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装qbittorrent,aria2,ari2-pro
6)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-3]****|"
TIME w "|******** QBITTORRENT & ARIA2 *********|"
TIME w "----------------------------------------"
TIME w "(1) 安装qbittorrent增强版"
TIME w "(2) 安装aria2"
TIME w "(3) 安装aria2-pro"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>请使用root账户部署容器"
TIME r "<注>aria2和aria2-pro 二选一"
 read -p "Please enter your Choice[0-3]: " input6
 case $input6 in 
 1)
    TIME y " >>>>>>>>>>>开始安装qbittorrent增强版"
  # 创建映射文件夹
  input_container_qb_config() {
  echo -n -e "请输入qbittorrent增强版配置文件保存的绝对路径（示例：/home/qbittorrent)，回车默认为当前目录: "
  read qb_path
  if [ -z "$qb_path" ]; then
      QB_PATH=$QB_CONFIG_FOLDER
  elif [ -d "$qb_path" ]; then
      QB_PATH=$qb_path
  else
      #mkdir -p $qb_path
      QB_PATH=$qb_path
  fi
  #QB_CONFIG_PATH=$QB_PATH/qbittorrent
  echo -n -e "请输入下载文件保存的绝对路径（示例：/home/downloads)，回车默认为当前目录: "
  read downloads_path
  if [ -z "$downloads_path" ]; then
      DOWNLOADS_PATH=$QB_DOWNLOADS_FOLDER
  elif [ -d "$downloads_path" ]; then
      DOWNLOADS_PATH=$downloads_path
  else
      #mkdir -p $downloads_path
      DOWNLOADS_PATH=$downloads_path
  fi
  }
  input_container_qb_config

  # 输入容器名
  input_container_qb_name() {
    echo -n -e "请输入将要创建的容器名[默认为：qbittorrent]-> "
    read container_name
    if [ -z "$container_name" ]; then
        QB_CONTAINER_NAME="qbittorrent"
    else
        QB_CONTAINER_NAME=$container_name
    fi
  }
  input_container_qb_name

  # 确认
  while true
  do
  	TIME y "qbittorrent 配置文件路径：$QB_PATH"
  	TIME y "qbittorrent 下载文件路径：$DOWNLOADS_PATH"
  	TIME y "qbittorrent 容器名：$QB_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input61
  	case $input61 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_qb_config
  			input_container_qb_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装qbittorrent"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $MOVIES_PATH $TVSHOWS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -v $QB_PATH:/config \
      -v $DOWNLOADS_PATH:/Downloads \
      -e WEBUIPORT=8989 \
      -p 6881:6881 -p 6881:6881/udp -p 8989:8989 \
      -e TZ=Asia/Shanghai \
      -e UID=0  \
      -e GID=0  \
      -e UMASK=022  \
      --name $QB_CONTAINER_NAME \
      --hostname $QB_CONTAINER_NAME \
      --restart always \
      $QB_DOCKER_IMG_NAME:$QB_TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "---------------------------------------------------------"
    TIME g "|      qbittorrent启动需要一点点时间，请耐心等待！      |"
    sleep 10
    TIME g "|               安装完成，自动退出脚本                  |"
    TIME g "|  qbittorrent默认端口为8989，如有修改请访问修改的端口  |"
    TIME g "|     访问方式为宿主机ip:端口(例192.168.2.1:8989)       |"
    TIME g "|         默认用户名admin，默认密码adminadmin           |"
    TIME g "---------------------------------------------------------"
  exit 0
  ;;
 2)
    TIME y " >>>>>>>>>>>开始安装aria2"
  # 创建映射文件夹
  input_container_aria2_config() {
  echo -n -e "请输入aria2配置文件保存的绝对路径（示例：/home/aria2)，回车默认为当前目录: "
  read aria2_path
  if [ -z "$aria2_path" ]; then
      ARIA2_PATH=$ARIA2_CONFIG_FOLDER
  elif [ -d "$aria2_path" ]; then
      ARIA2_PATH=$aria2_path
  else
      #mkdir -p $aria2_path
      ARIA2_PATH=$aria2_path
  fi
  echo -n -e "请输入下载文件保存的绝对路径（示例：/home/downloads)，回车默认为当前目录: "
  read downloads_path
  if [ -z "$downloads_path" ]; then
      DOWNLOADS_PATH=$ARIA2_DOWNLOADS_FOLDER
  elif [ -d "$downloads_path" ]; then
      DOWNLOADS_PATH=$downloads_path
  else
      #mkdir -p $downloads_path
      DOWNLOADS_PATH=$downloads_path
  fi
  }
  input_container_aria2_config
  
  # 输入容器名
  input_container_aria2_name() {
    echo -n -e "请输入将要创建的容器名[默认为：aria2]-> "
    read container_name
    if [ -z "$container_name" ]; then
        ARIA2_CONTAINER_NAME="aria2"
    else
        ARIA2_CONTAINER_NAME=$container_name
    fi
  }
  input_container_aria2_name
  
  # TOKEN
  input_container_aria2_token() {
  inp "是否修改密钥[默认 aria2]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_token
  if [ "$change_token" = "1" ]; then
      echo -n -e "输入想修改的密钥-> "
      read TOKEN
  fi
  }
  input_container_aria2_token

  # 确认
  while true
  do
  	TIME y "aria2 配置文件路径：$ARIA2_PATH"
  	TIME y "aria2 下载文件路径：$DOWNLOADS_PATH"
  	TIME y "aria2 容器名：$ARIA2_CONTAINER_NAME"
  	TIME y "aria2 密钥：$TOKEN"
  	read -r -p "以上信息是否正确？[Y/n] " input62
  	case $input62 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_aria2_config
  			input_container_aria2_name
  			input_container_aria2_token
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装aria2"
  log "1.开始创建配置文件目录"
  PATH_LIST=($ARIA2_PATH $DOWNLOADS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -v $ARIA2_PATH:/config \
      -v $DOWNLOADS_PATH:/downloads \
      -e WEBUIPORT=8080 \
      -p 32516:32516 -p 32516:32516/udp -p 6800:6800 -p 8080:8080 \
      -e TZ=Asia/Shanghai \
      -e SECRET=$TOKEN \
      -e UID=0  \
      -e GID=0  \
      -e CACHE=512M \
      -e PORT=6800 \
      -e BTPORT=32516 \
      -e UT=true \
      -e RUT=true \
      -e FA=falloc \
      -e QUIET=true \
      -e SMD=false \
      --name $ARIA2_CONTAINER_NAME \
      --hostname $ARIA2_CONTAINER_NAME \
      --restart always \
      $ARIA2_DOCKER_IMG_NAME:$ARIA2_TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "---------------------------------------------------------"
    TIME g "|          aria2启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                 安装完成，自动退出脚本                |"
    TIME g "|     aria2默认端口为8080，如有修改请访问修改的端口     |"
    TIME g "|     访问方式为宿主机ip:端口(例192.168.2.1:8080)       |"
    TIME g "|              Aria密钥设置在面板如下位置               |"
    TIME g "|      AriaNg设置 > RPC(IP:6800) > Aria2 RPC 密钥       |"
    TIME g "---------------------------------------------------------"
    TIME z "                  设置的密钥为 $TOKEN"
  exit 0
  ;;
 3)
    TIME y " >>>>>>>>>>>开始安装aria2-pro"
  # 创建映射文件夹
  input_container_aria2_pro_config() {
  echo -n -e "请输入aria2-pro配置文件保存的绝对路径（示例：/home/aria2-pro)，回车默认为当前目录: "
  read aria2_pro_path
  if [ -z "$aria2_pro_path" ]; then
      ARIA2_PRO_PATH=$ARIA2_PRO_CONFIG_FOLDER
  elif [ -d "$aria2_pro_path" ]; then
      ARIA2_PRO_PATH=$aria2_pro_path
  else
      #mkdir -p $aria2_pro_path
      ARIA2_PRO_PATH=$aria2_pro_path
  fi
  echo -n -e "请输入下载文件保存的绝对路径（示例：/home/downloads)，回车默认为当前目录: "
  read downloads_path
  if [ -z "$downloads_path" ]; then
      DOWNLOADS_PATH=$ARIA2_PRO_DOWNLOADS_FOLDER
  elif [ -d "$downloads_path" ]; then
      DOWNLOADS_PATH=$downloads_path
  else
      #mkdir -p $downloads_path
      DOWNLOADS_PATH=$downloads_path
  fi
  }
  input_container_aria2_pro_config
  
  # 输入容器名
  input_container_aria2_pro_name() {
    echo -n -e "请输入将要创建的容器名[默认为：aria2-pro]-> "
    read container_name
    if [ -z "$container_name" ]; then
        ARIA2_PRO_CONTAINER_NAME="aria2-pro"
    else
        ARIA2_PRO_CONTAINER_NAME=$container_name
    fi
  }
  input_container_aria2_pro_name
  # 输入容器名(面板)
  input_container_ariang_name() {
    echo -n -e "请输入将要创建的面板容器名[默认为：ariang]-> "
    read container_name1
    if [ -z "$container_name1" ]; then
        ARIA2_PRO_WEBUI_NAME="ariang"
    else
        ARIA2_PRO_WEBUI_NAME=$container_name1
    fi
  }
  input_container_ariang_name
  # TOKEN
  input_container_aria2_pro_token() {
  inp "是否修改密钥[默认 aria2]：\n1) 修改\n2) 不修改[默认]"
  opt
  read change_token
  if [ "$change_token" = "1" ]; then
      echo -n -e "输入想修改的密钥-> "
      read TOKEN
  fi
  }
  input_container_aria2_pro_token

  # 确认
  while true
  do
  	TIME y "aria2_pro 配置文件路径：$ARIA2_PRO_PATH"
  	TIME y "aria2_pro 下载文件路径：$DOWNLOADS_PATH"
  	TIME y "aria2_pro 容器名：$ARIA2_PRO_CONTAINER_NAME"
  	TIME y "aria2_pro 面板名：$ARIA2_PRO_WEBUI_NAME"
  	TIME y "aria2_pro 密钥：$TOKEN"
  	read -r -p "以上信息是否正确？[Y/n] " input63
  	case $input63 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_aria2_pro_config
  			input_container_aria2_pro_name
  			input_container_ariang_name
  			input_container_aria2_pro_token
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装aria2-pro"
  log "1.开始创建配置文件目录"
  PATH_LIST=($ARIA2_PRO_PATH $DOWNLOADS_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -v $ARIA2_PRO_PATH:/config \
      -v $DOWNLOADS_PATH:/downloads \
      -p 6800:6800 -p 6888:6888 -p 6888:6888/udp \
      -e TZ=Asia/Shanghai \
      -e RPC_SECRET=$TOKEN \
      -e RPC_PORT=6800 \
      -e LISTEN_PORT=6888 \
      -e UID=0  \
      -e GID=0  \
      -e UMASK_SET=022 \
      --log-opt max-size=1m \
      --name $ARIA2_PRO_CONTAINER_NAME \
      --hostname $ARIA2_PRO_CONTAINER_NAME \
      --restart always \
      $ARIA2_PRO_DOCKER_IMG_NAME:$TAG

  docker run -d \
      --name $ARIA2_PRO_WEBUI_NAME \
      --log-opt max-size=1m \
      --restart unless-stopped \
      -p 6880:6880 \
      $ARIA2_PRO_WEBUI_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "------------------------------------------------------------"
    TIME g "|         aria2-pro启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                    安装完成，自动退出脚本                |"
    TIME g "|     aria2-pro默认端口为8080，如有修改请访问修改的端口    |"
    TIME g "|        访问方式为宿主机ip:端口(例192.168.2.1:6880)       |"
    TIME g "|                 Aria密钥设置在面板如下位置               |"
    TIME g "|        AriaNg设置 > RPC(IP:6800) > Aria2 RPC 密钥        |"
    TIME g "------------------------------------------------------------"
    TIME z "                  设置的密钥为 $TOKEN"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装telethon
7)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|************** TELETHON **************|"
TIME w "----------------------------------------"
TIME w "(1) linxu系统、X86的openwrt、群辉等请选择 1"
TIME w "(2) N1的EMMC上运行的openwrt请选择 2"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>选择1或2后，如果不明白如何选择或输入，请狂按回车！"
 read -p "Please enter your choice[0-2]: " input7
 case $input7 in 
 1)
  TIME y " >>>>>>>>>>>开始安装telethon"
  # 创建映射文件夹
  input_container_telethon1_config() {
  echo -n -e "请输入telethon配置文件保存的绝对路径（示例：/home/telethon)，回车默认为当前目录: "
  read tg_path
  if [ -z "$tg_path" ]; then
      TG_PATH=$TG_SHELL_FOLDER
  elif [ -d "$tg_path" ]; then
      TG_PATH=$tg_path
  else
      #mkdir -p $tg_path
      TG_PATH=$tg_path
  fi
  CONFIG_PATH=$TG_PATH
  }
  input_container_telethon1_config

  # 输入容器名
  input_container_telethon1_name() {
    echo -n -e "请输入将要创建的容器名[默认为：telethon]-> "
    read container_name
    if [ -z "$container_name" ]; then
        TG_CONTAINER_NAME="telethon"
    else
        TG_CONTAINER_NAME=$container_name
    fi
  }
  input_container_telethon1_name

  # 确认
  while true
  do
  	TIME y "telethon 配置文件路径：$CONFIG_PATH"
  	TIME y "telethon 容器名：$TG_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input71
  	case $input71 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_telethon1_config
  			input_container_telethon1_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装telethon"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/telethon \
      --name $TG_CONTAINER_NAME \
      --hostname $TG_CONTAINER_NAME \
      --restart always \
      --net host \
      $TG_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|         telethon启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "| 使用教程https://hub.docker.com/r/kissyouhunter/telethon |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 2)  
  TIME y " >>>>>>>>>>>开始安装telethon到N1的/mnt/mmcblk2p4/"
  # 创建映射文件夹
  input_container_telethon2_config() {
  echo -n -e "请输入telethon存储的文件夹名称（如：telethon)，回车默认为 telethon: "
  read tg_path
  if [ -z "$tg_path" ]; then
      TG_PATH=$N1_TG_FOLDER
  elif [ -d "$tg_path" ]; then
      TG_PATH=/mnt/mmcblk2p4/$tg_path
  else
      #mkdir -p /mnt/mmcblk2p4/$tg_path
      TG_PATH=/mnt/mmcblk2p4/$tg_path
  fi
  CONFIG_PATH=$TG_PATH
  }
  input_container_telethon2_config
  
  # 输入容器名
  input_container_telethon2_name() {
    echo -n -e "请输入将要创建的容器名[默认为：telethon]-> "
    read container_name
    if [ -z "$container_name" ]; then
        TG_CONTAINER_NAME="telethon"
    else
        TG_CONTAINER_NAME=$container_name
    fi
  }
  input_container_telethon2_name

  # 确认
  while true
  do
  	TIME y "telethon 配置文件路径：$CONFIG_PATH"
  	TIME y "telethon 容器名：$TG_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input72
  	case $input72 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_telethon2_config
  			input_container_telethon2_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装telethon"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "3.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/telethon \
      --name $TG_CONTAINER_NAME \
      --hostname $TG_CONTAINER_NAME \
      --restart always \
      --net host \
      $TG_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|         telethon启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "| 使用教程https://hub.docker.com/r/kissyouhunter/telethon |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
 ;;
#安装adguardhome
8)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-3]****|"
TIME w "|************* ADGUARDHOME ************|"
TIME w "----------------------------------------"
TIME w "(1) linxu系统、X86的openwrt、群辉等（docker版）请选择 1"
TIME w "(2) N1的EMMC上运行的openwrt（docker版）请选择 2"
TIME w "(3) linxu系统（非docker版，openwrt不可运行）"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>选择1或2后，如果不明白如何选择或输入，请狂按回车！"
 read -p "Please enter your choice[0-3]: " input8
 case $input8 in 
 1)
  TIME y " >>>>>>>>>>>开始安装adguardhome（docker版，x86系统）"
  # 创建映射文件夹
  input_container_adg1_config() {
  echo -n -e "请输入adguardhome配置文件保存的绝对路径（示例：/home/adguardhome)，回车默认为当前目录: "
  read adg_path
  if [ -z "$adg_path" ]; then
      ADG_PATH=$ADG_CONFIG_FOLDER
  elif [ -d "$adg_path" ]; then
      ADG_PATH=$adg_path
  else
      #mkdir -p ${adg_path}/work
      #mkdir -p ${adg_path}/conf
      ADG_PATH=$adg_path
  fi
  CONFIG_PATH=$ADG_PATH
  WORK_PATH=$ADG_PATH/work
  CONF_PATH=$ADG_PATH/conf
  }
  input_container_adg1_config

  # 输入容器名
  input_container_adg1_name() {
    echo -n -e "请输入将要创建的容器名[默认为：adguardhome]-> "
    read container_name
    if [ -z "$container_name" ]; then
        ADG_CONTAINER_NAME="adguardhome"
    else
        ADG_CONTAINER_NAME=$container_name
    fi
  }
  input_container_adg1_name

  # 确认
  while true
  do
  	TIME y "adguardhome 配置文件路径：$CONFIG_PATH"
  	TIME y "adguardhome 容器名：$ADG_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input81
  	case $input81 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_adg1_config
  			input_container_adg1_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装adguardhome（docker版，x86系统）"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $WORK_PATH $CONF_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $WORK_PATH:/opt/adguardhome/work \
      -v $CONF_PATH:/opt/adguardhome/conf \
      --name $ADG_CONTAINER_NAME \
      --hostname $ADG_CONTAINER_NAME \
      --restart always \
      --net host \
      $ADG_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|       adguardhome启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "|            首次启动请访问宿主机 IP:3000                 |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 2)  
  TIME y " >>>>>>>>>>>开始安装adguardhome（docker版）到N1的/mnt/mmcblk2p4/"
  # 创建映射文件夹
  input_container_adg2_config() {
  echo -n -e "请输入adguardhome存储文件名名称（示例：adguardhome)，回车默认为adguardhome: "
  read adg_path
  if [ -z "$adg_path" ]; then
      ADG_PATH=$N1_ADG_FOLDER
  elif [ -d "$adg_path" ]; then
      ADG_PATH=/mnt/mmcblk2p4/$adg_path
  else
      #mkdir -p /mnt/mmcblk2p4/$adg_path/work
      #mkdir -p /mnt/mmcblk2p4/$adg_path/conf
      ADG_PATH=/mnt/mmcblk2p4/$adg_path
  fi
  CONFIG_PATH=$ADG_PATH
  WORK_PATH=$ADG_PATH/work
  CONF_PATH=$ADG_PATH/conf
  }
  input_container_adg2_config

  # 输入容器名
  input_container_adg2_name() {
    echo -n -e "请输入将要创建的容器名[默认为：adguardhome]-> "
    read container_name
    if [ -z "$container_name" ]; then
        ADG_CONTAINER_NAME="adguardhome"
    else
        ADG_CONTAINER_NAME=$container_name
    fi
  }
  input_container_adg2_name

  # 确认
  while true
  do
  	TIME y "adguardhome 配置文件路径：$CONFIG_PATH"
  	TIME y "adguardhome 容器名：$ADG_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input82
  	case $input82 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_adg2_config
  			input_container_adg2_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装adguardhome（docker版）到N1的/mnt/mmcblk2p4/"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $WORK_PATH $CONF_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "3.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $WORK_PATH:/opt/adguardhome/work \
      -v $CONF_PATH:/opt/adguardhome/conf \
      --name $ADG_CONTAINER_NAME \
      --hostname $ADG_CONTAINER_NAME \
      --restart always \
      --net host \
      $ADG_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|       adguardhome启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "|            首次启动请访问宿主机 IP:3000                 |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 3)  
  TIME y " >>>>>>>>>>>开始安装adguardhome（非docker版）"
  apt update && apt install curl -y
  curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
    TIME g "-----------------------------------------------------------"
    TIME g "|       adguardhome启动需要一点点时间，请耐心等待！       |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "|            首次启动请访问宿主机 IP:3000                 |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;; 
#安装x-ui
9)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-3]****|"
TIME w "|**************** X-UI ****************|"
TIME w "----------------------------------------"
TIME w "(1) x-ui为docer版本"
TIME b "(0) 返回上级菜单"
#EOF
 read -p "Please enter your choice[0-1]: " input9
 case $input9 in 
 1)
  TIME y " >>>>>>>>>>>开始安装x-ui"
  # 创建映射文件夹
  input_container_xui_config() {
  echo -n -e "请输入x-ui配置文件保存的绝对路径（示例：/home/x-ui)，回车默认为当前目录: "
  read xui_path
  if [ -z "$xui_path" ]; then
      XUI_PATH=$XUI_CONFIG_FOLDER
  elif [ -d "$xui_path" ]; then
      XUI_PATH=$xui_path
  else
      #mkdir -p ${xui_path}/db
      #mkdir -p ${xui_path}/cert
      XUI_PATH=$xui_path
  fi
  CONFIG_PATH=$XUI_PATH
  DB_PATH=$XUI_PATH/db
  CERT_PATH=$XUI_PATH/cert
  }
  input_container_xui_config

  # 输入容器名
  input_container_xui_name() {
    echo -n -e "请输入将要创建的容器名[默认为：x-ui]-> "
    read container_name
    if [ -z "$container_name" ]; then
        XUI_CONTAINER_NAME="x-ui"
    else
        XUI_CONTAINER_NAME=$container_name
    fi
  }
  input_container_xui_name

  # image 版本
  input_container_xui_image() {
    echo -n -e "请输入将要拉取镜像[默认为：最新版本latest，输入dev为尝鲜版]-> "
    read image_name
    if [ -z "$image_name" ]; then
        XUI_IMAGE_NAME="latest"
    elif [ "$image_name" == "latest" ]; then
        XUI_IMAGE_NAME="latest"
    else
        XUI_IMAGE_NAME=$DEV
    fi
  }
  input_container_xui_image

  # 确认
  while true
  do
  	TIME y "x-ui 配置文件路径：$CONFIG_PATH"
  	TIME y "x-ui 容器名：$XUI_CONTAINER_NAME"
    TIME y "x-ui 镜像版本：$XUI_IMAGE_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input91
  	case $input91 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_xui_config
  			input_container_xui_name
            input_container_xui_image
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装x-ui"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH $DB_PATH $CERT_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $DB_PATH:/etc/x-ui/ \
      -v $CERT_PATH:/root/ \
      --name $XUI_CONTAINER_NAME \
      --hostname $XUI_CONTAINER_NAME \
      --restart always \
      --net host \
      $XUI_DOCKER_IMG_NAME:$XUI_IMAGE_NAME

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|             x-ui启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "|      默认账号：admin 默认密码：admin 默认端口：54321    |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
0)
clear
exit 0
;;
#安装aapanel
10)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|******** AAPANEL(宝塔国际版) *********|"
TIME w "----------------------------------------"
TIME w "(1) linxu系统、X86的openwrt、群辉等请选择 1"
TIME w "(2) N1的EMMC上运行的openwrt请选择 2"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>选择1或2后，如果不明白如何选择或输入，请狂按回车！"
 read -p "Please enter your choice[0-2]: " input10
 case $input10 in 
 1)
  TIME y " >>>>>>>>>>>开始安装aapanel"
  # 创建映射文件夹
  input_container_aapanel1_config() {
  echo -n -e "请输入aapanel配置文件保存的绝对路径（示例：/home/aapanel)，回车默认为当前目录: "
  read aapanel_path
  if [ -z "$aapanel_path" ]; then
      AAPANEL_PATH=$AAPANEL_CONFIG_FOLDER
  elif [ -d "$aapanel_path" ]; then
      AAPANEL_PATH=$aapanel_path
  else
      AAPANEL_PATH=$aapanel_path
  fi
  CONFIG_PATH=$AAPANEL_PATH
  WEBSITE_DATA_PATH=$AAPANEL_PATH/website_data
  MYSQL_DATA_PATH=$AAPANEL_PATH/mysql_data
  VHOST_PATH=$AAPANEL_PATH/vhost
  }
  input_container_aapanel1_config

  # 输入容器名
  input_container_aapanel1_name() {
    echo -n -e "请输入将要创建的容器名[默认为：aapanel]-> "
    read container_name
    if [ -z "$container_name" ]; then
        AAPANEL_CONTAINER_NAME="aapanel"
    else
        AAPANEL_CONTAINER_NAME=$container_name
    fi
  }
  input_container_aapanel1_name

  # 确认
  while true
  do
  	TIME y "aapanel 配置文件路径：$CONFIG_PATH"
  	TIME y "aapanel 容器名：$AAPANEL_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input101
  	case $input101 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_aapanel1_config
  			input_container_aapanel1_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装aapanel"
  log "1.开始创建配置文件目录"
  PATH_LIST=($MYSQL_DATA_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done
  PATH_LIST=($WEBSITE_DATA_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done
  PATH_LIST=($VHOST_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $WEBSITE_DATA_PATH:/www/wwwroot \
      -v $MYSQL_DATA_PATH:/www/server/data \
      -v $VHOST_PATH:/www/server/panel/vhost \
      --name $AAPANEL_CONTAINER_NAME \
      --hostname $AAPANEL_CONTAINER_NAME \
      --restart always \
      --net host \
      $AAPANEL_DOCKER_IMG_NAME:$AAPANEL_TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|          aapanel启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "|            访问方式为 宿主机ip:8888/aapanel/            |"
    TIME g "|        默认账号：aapanel  默认密码：aapanel123          |"
    TIME g "|   基础教程 https://wiki.991231.xyz/zh/docker/aapanel    |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 2)  
  TIME y " >>>>>>>>>>>开始安装aapanel到N1的/mnt/mmcblk2p4/"
  # 创建映射文件夹
  input_container_aapanel2_config() {
  echo -n -e "请输入telethon存储的文件夹名称（如：aapanel)，回车默认为 aapanel: "
  read aapanel_path
  if [ -z "$aapanel_path" ]; then
      AAPANEL_PATH=$N1_AAPANEL_FOLDER
  elif [ -d "$aapanel_path" ]; then
      AAPANEL_PATH=/mnt/mmcblk2p4/$aapanel_path
  else
      #mkdir -p /mnt/mmcblk2p4/$aapanel_path
      AAPANEL_PATH=/mnt/mmcblk2p4/$aapanel_path
  fi
  CONFIG_PATH=$AAPANEL_PATH
  WEBSITE_DATA_PATH=$AAPANEL_PATH/website_data
  MYSQL_DATA_PATH=$AAPANEL_PATH/mysql_data
  VHOST_PATH=$AAPANEL_PATH/vhost
  }
  input_container_aapanel2_config
  
  # 输入容器名
  input_container_aapanel2_name() {
    echo -n -e "请输入将要创建的容器名[默认为：aapanel]-> "
    read container_name
    if [ -z "$container_name" ]; then
        AAPANEL_CONTAINER_NAME="aapanel"
    else
        AAPANEL_CONTAINER_NAME=$container_name
    fi
  }
  input_container_aapanel2_name

  # 确认
  while true
  do
  	TIME y "aapanel 配置文件路径：$CONFIG_PATH"
  	TIME y "aapanel 容器名：$AAPANEL_CONTAINER_NAME"
  	read -r -p "以上信息是否正确？[Y/n] " input102
  	case $input102 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_aapanel2_config
  			input_container_aapanel2_name
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装aapanel"
  log "1.开始创建配置文件目录"
  PATH_LIST=($MYSQL_DATA_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done
  PATH_LIST=($WEBSITE_DATA_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done
  PATH_LIST=($VHOST_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "3.开始创建容器并执行"
  docker run -dit \
      -t \
      -v $WEBSITE_DATA_PATH:/www/wwwroot \
      -v $MYSQL_DATA_PATH:/www/server/data \
      -v $VHOST_PATH:/www/server/panel/vhost \
      --name $AAPANEL_CONTAINER_NAME \
      --hostname $AAPANEL_CONTAINER_NAME \
      --restart always \
      --net host \
      $AAPANEL_DOCKER_IMG_NAME:$AAPANEL_TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "-----------------------------------------------------------"
    TIME g "|          aapanel启动需要一点点时间，请耐心等待！        |"
    sleep 10
    TIME g "|                安装完成，自动退出脚本                   |"
    TIME g "|            访问方式为 宿主机ip:8888/aapanel/            |"
    TIME g "|        默认账号：aapanel  默认密码：aapanel123          |"
    TIME g "|   基础教程 https://wiki.991231.xyz/zh/docker/aapanel    |"
    TIME g "-----------------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
#安装MaiARK
11)
clear
while [ "$flag" -eq 0 ]
do
#cat << EOF
TIME w "----------------------------------------"
TIME w "|****Please Enter Your Choice:[0-2]****|"
TIME w "|************** MaiARK ****************|"
TIME w "----------------------------------------"
TIME w "(1) linxu系统、openwrt、群辉等请选择 1"
TIME w "(2) N1的EMMC上运行的openwrt请选择 2"
TIME b "(0) 返回上级菜单"
#EOF
TIME r "<注>选择后，如果不明白如何选择或输入，请狂按回车！"
 read -p "Please enter your choice[0-2]: " input11
 case $input11 in 
 1)
  TIME y " >>>>>>>>>>>开始安装MaiARK (AMD64 CPU)"
  # 创建映射文件夹
  input_container_maiark1_config() {
  echo -n -e "请输入MaiARK配置文件保存的绝对路径（示例：/home/MaiARK)，回车默认为当前目录: "
  read maiark_path
  if [ -z "$maiark_path" ]; then
      MAIARK_PATH=$MAIARK_CONFIG_FOLDER
  elif [ -d "$maiark_path" ]; then
      MAIARK_PATH=$maiark_path
  else
      MAIARK_PATH=$maiark_path
  fi
  CONFIG_PATH=$MAIARK_PATH
  }
  input_container_maiark1_config

  # 输入容器名
  input_container_maiark1_name() {
    echo -n -e "请输入将要创建的容器名[默认为：maiark]-> "
    read container_name
    if [ -z "$container_name" ]; then
        MAIARK_CONTAINER_NAME="maiark"
    else
        MAIARK_CONTAINER_NAME=$container_name
    fi
  }
  input_container_maiark1_name

  # 网络模式
  input_container_maiark1_network_config() {
  inp "请选择容器的网络类型：\n1) host\n2) bridge[默认]"
  opt
  read net
  if [ "$net" = "1" ]; then
      NETWORK="host"
      MAIARK_PORT="8082"
  fi
  
  if [ "$NETWORK" = "bridge" ]; then
      inp "是否修改MaiMRK端口[默认 8082]：\n1) 修改\n2) 不修改[默认]"
      opt
      read change_maiark_port
      if [ "$change_maiark_port" = "1" ]; then
          echo -n -e "输入想修改的端口->"
          read MAIARK_PORT
          echo $MAIARK_PORT
      else
          MAIARK_PORT="8082"
      fi
  fi
  }
  input_container_maiark1_network_config

  # 确认
  while true
  do
  	TIME y "MaiARK 配置文件路径：$CONFIG_PATH"
  	TIME y "Maiark 容器名：$MAIARK_CONTAINER_NAME"
    TIME y "Maiark 端口：$MAIARK_PORT"
    TIME r "确认下映射路径是否正确！！！"
  	read -r -p "以上信息是否正确？[Y/n] " input111
  	case $input111 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_maiark1_config
  			input_container_maiark1_name
            input_container_maiark1_network_config
            MAIARK_PORT="8082"
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装MaiARK"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "2.开始创建容器并执行"
  docker pull $MAIARK_DOCKER_IMG_NAME:$TAG
  docker run -d \
      -v $CONFIG_PATH:/MaiARK \
      --name $MAIARK_CONTAINER_NAME \
      --hostname $MAIARK_CONTAINER_NAME \
      --restart always \
      --network $NETWORK \
      -p $MAIARK_PORT:8082 \
      $MAIARK_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "------------------------------------------------------------------------------"
    TIME g "|                   MaiARK启动需要一点点时间，请耐心等待！                   |"
    sleep 10
    TIME g "|                          安装完成，自动退出脚本                            |"
    TIME g "|                          访问方式为 宿主机ip:$MAIARK_PORT                          |"
    TIME g "|              请先配置好映射文件夹下的arkconfig.json再重启容器              |"
    TIME r "|  桥接模式请不要修改config下的端口8082，host模式随意(前提是指定自己在干啥)  |"
    TIME r "|                 请看清映射的文件夹路径去找config文件                       |"
    TIME r "|   op用户出现“docker0: iptables: No chain/target/match by that name”错误    |"
    TIME r "|              输入命令“/etc/init.d/dockerd restart” 重启docker              |"
    TIME r "|                     再输入“docker start $MAIARK_CONTAINER_NAME” 启动容器                   |"
    TIME r "|       op用户出现容器正常启动，但web界面无法方法Turbo ACC 网络加速设置      |"
    TIME r "|进入“网络——Turbo ACC 网络加速设置” 开启或关闭“全锥型 NAT”就可正常访问web界面|"
    TIME g "------------------------------------------------------------------------------"
  exit 0
  ;;
 2)  
  TIME y " >>>>>>>>>>>开始安装MaiARK到N1的/mnt/mmcblk2p4/"
  # 创建映射文件夹
  input_container_maiark3_config() {
  echo -n -e "请输入MaiARK存储的文件夹名称（如：MaiARK)，回车默认为 MaiARK: "
  read maiark_path
  if [ -z "$maiark_path" ]; then
      MAIARK_PATH=$N1_MAIARK_FOLDER
  elif [ -d "$maiark_path" ]; then
      MAIARK_PATH=/mnt/mmcblk2p4/$maiark_path
  else
      MAIARK_PATH=/mnt/mmcblk2p4/$maiark_path
  fi
  CONFIG_PATH=$MAIARK_PATH
  }
  input_container_maiark3_config
  
  # 输入容器名
  input_container_maiark3_name() {
    echo -n -e "请输入将要创建的容器名[默认为：maiark]-> "
    read container_name
    if [ -z "$container_name" ]; then
        MAIARK_CONTAINER_NAME="maiark"
    else
        MAIARK_CONTAINER_NAME=$container_name
    fi
  }
  input_container_maiark3_name

  # 网络模式
  input_container_maiark3_network_config() {
  inp "请选择容器的网络类型：\n1) host\n2) bridge[默认]"
  opt
  read net
  if [ "$net" = "1" ]; then
      NETWORK="host"
      MAIARK_PORT="8082"
  fi
  
  if [ "$NETWORK" = "bridge" ]; then
      inp "是否修改MaiMRK端口[默认 8082]：\n1) 修改\n2) 不修改[默认]"
      opt
      read change_maiark_port
      if [ "$change_maiark_port" = "1" ]; then
          echo -n -e "输入想修改的端口->"
          read MAIARK_PORT
      else
          MAIARK_PORT="8082"
      fi
  fi
  }
  input_container_maiark3_network_config


  # 确认
  while true
  do
  	TIME y "MaiARK 配置文件路径：$CONFIG_PATH"
  	TIME y "MaiARK 容器名：$MAIARK_CONTAINER_NAME"
    TIME y "Maiark 端口：$MAIARK_PORT"
    TIME r "确认下映射路径是否正确！！！"
  	read -r -p "以上信息是否正确？[Y/n] " input113
  	case $input113 in
  		[yY][eE][sS]|[yY])
  			break
  			;;
  		[nN][oO]|[nN])
  			TIME w "即将返回上一步"
  			sleep 1
  			input_container_maiark3_config
  			input_container_maiark3_name
            input_container_maiark3_network_config
            MAIARK_PORT="8082"
  			;;
  		*)
  			TIME r "输入错误，请输入[Y/n]"
  			;;
  	esac
  done

  TIME y " >>>>>>>>>>>配置完成，开始安装MaiARK"
  log "1.开始创建配置文件目录"
  PATH_LIST=($CONFIG_PATH)
  for i in ${PATH_LIST[@]}; do
      mkdir -p $i
  done

  log "3.开始创建容器并执行"
  docker pull $MAIARK_DOCKER_IMG_NAME:$TAG
  docker run -dit \
      -t \
      -v $CONFIG_PATH:/MaiARK \
      --name $MAIARK_CONTAINER_NAME \
      --hostname $MAIARK_CONTAINER_NAME \
      --restart always \
      --network $NETWORK \
      -p $MAIARK_PORT:8082 \
      $MAIARK_DOCKER_IMG_NAME:$TAG

      if [ $? -ne 0 ] ; then
          cancelrun "** 错误：容器创建失败，请翻译以上英文报错，Google/百度尝试解决问题！"
      fi

      log "列出所有宿主机上的容器"
      docker ps -a
    TIME g "------------------------------------------------------------------------------"
    TIME g "|                   MaiARK启动需要一点点时间，请耐心等待！                   |"
    sleep 10
    TIME g "|                          安装完成，自动退出脚本                            |"
    TIME g "|                          访问方式为 宿主机ip:$MAIARK_PORT                          |"
    TIME g "|              请先配置好映射文件夹下的arkconfig.json再重启容器              |"
    TIME r "|  桥接模式请不要修改config下的端口8082，host模式随意(前提是指定自己在干啥)  |"
    TIME r "|                 请看清映射的文件夹路径去找config文件                       |"
    TIME r "|   op用户出现“docker0: iptables: No chain/target/match by that name”错误    |"
    TIME r "|              输入命令“/etc/init.d/dockerd restart” 重启docker              |"
    TIME r "|                     再输入“docker start $MAIARK_CONTAINER_NAME” 启动容器                   |"
    TIME r "|       op用户出现容器正常启动，但web界面无法方法Turbo ACC 网络加速设置      |"
    TIME r "|进入“网络——Turbo ACC 网络加速设置” 开启或关闭“全锥型 NAT”就可正常访问web界面|"
    TIME g "------------------------------------------------------------------------------"
  exit 0
  ;;
 0) 
 clear 
 break
 ;;
 *) TIME r "----------------------------------"
    TIME r "|          Warning!!!            |"
    TIME r "|       请输入正确的选项!        |"
    TIME r "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
 ;;
 esac
 done
;;
*) TIME r "----------------------------------"
 TIME r "|          Warning!!!            |"
 TIME r "|       请输入正确的选项!        |"
 TIME r  "----------------------------------"
 for i in $(seq -w 1 -1 1)
   do
     #TIME r "\b\b$i";
     sleep 1;
   done
 clear
;;
esac
done
