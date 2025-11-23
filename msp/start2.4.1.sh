#!/bin/sh

choice=${1:-}

# ── 普通前景色 ----------
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PEOPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# ── 普通背景色 ----------
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

N='\033[0m'

clear
echo -n "${GREEN}==== Termux 启动菜单 ====${N}\n"
echo -n "${CYAN}$0${N}\n"
echo "0.强制退出菜单"
echo "1.启动 NetHunter"
echo "2.启动 VNC 服务器"
echo "3.启动 ADB 服务"
echo "4.一键打包GKD订阅"
echo "5.编辑~/.bashrc"
echo "6.编辑此脚本"
echo "7.备份~/.bashrc或此脚本"
echo "8.提醒管理"
echo "9.获取termux原版启动页"
echo "10.添加命令"
echo "11.尝试调用tmoe"
echo "12.启动python静态文件服务器"
echo "13.使用shc/unshc加解密脚本"
echo "14.检查脚本是否有错"
echo "15.使用base64编解码文本"
echo "16.生成隐私脚本"
echo "17.安装所有可用的shell环境"
echo "18.IP地址信息查询"
echo "19.hitokoto一言句子获取"
echo "h.获取帮助"
echo "*.退出"
echo -n "${GREEN}========================${N}\n"
printf "请输入选项："
read choice

case $choice in
    0)
        exit 2
        ;;
    1)
	command -v nethunter >/dev/null || { echo "未安装nethunter"; exit 1; }
        nethunter
        ;;
    2)
        startvnc
        ;;
    3)
        adb start-server
        ;;
    4)
	wget --retry-connrefused --waitretry=5 -t 3 "https://q1050.webgetstore.com/2025/07/22/1a72471716cd89d01cadd926d0151555.zip?sg=329f8f90c279e093ca38a40da766422d&e=68804fbe&fileName=GKD%E8%AE%A2%E9%98%85-1753156857692.zip"
	echo "文件保存路径：/sdcard/download"
        ;;
    5)
        nano ~/.bashrc
        ;;
    6)
        nano "$0"
        ;;
    7)
        printf "备份~/.bashrc请输入B，备份此脚本请输入S，全部备份请输入all："
        read input
        case $input in
            B|b)
                cp ~/.bashrc "$HOME/storage/shared/"
                echo "已备份 ~/.bashrc 到 /sdcard/"
                ;;
            S|s)
                cp "$0" "$HOME/storage/shared/"
                echo "已备份本脚本到 /sdcard/starter.sh.bak"
                ;;
            all|All|ALL)
                cp ~/.bashrc "$HOME/storage/shared/"
                cp "$0" "$HOME/storage/shared/"
                echo "已全部备份到 /sdcard"
                ;;
            *)
                echo "退出"
                ;;
        esac
        ;;
    8)
	path=$(pwd)
	date=$(date +"%Y-%m-%d %H:%M")
	cd ~/storage/
        echo "添加提醒[1]，查看提醒[2]，清空提醒[3]"
	read choose
	case $choose in
	1)
	   echo "请输入提醒："
	   read input
	   echo "$date: $input\n" >> remind.txt
           ;;
	2)
	   cat remind.txt
	   ;;
	3)
	   > remind.txt
	   ;;
	esac
	cd "$path"
	;;
    9)
        cat <<'EOF'
Welcome to Termux!

Docs:       https://termux.dev/docs
Donate:     https://termux.dev/donate
Community:  https://termux.dev/community

Working with packages:

 - Search:  pkg search <query>
 - Install: pkg install <package>
 - Upgrade: pkg upgrade

Subscribing to additional repositories:

 - Root:    pkg install root-repo
 - X11:     pkg install x11-repo

For fixing any repository issues,
try 'termux-change-repo' command.

Report issues at https://termux.dev/issues
EOF
        ;;
    10)
        printf "输入命令名称："
        read cmd
        printf "输入此命令将执行的内容："
        read run
        echo "alias $cmd=\"$run\"" >> ~/.bashrc
        . ~/.bashrc
        echo "已添加 alias $cmd"
        ;;
    11)
        bash -c "$(curl -L 'https://gitee.com/mo2/linux/raw/2/2')"
        ;;
    12)
        printf "输入端口号（默认8000）："
        read port
        port=${port:-8000}
        printf "输入服务器根路径（默认当前目录）："
        read path
        path=${path:-.}
        cd "$path" && python -m http.server "$port"
        ;;
    13)
        echo "请先输入文件路径"
        read path
        echo "请选择用GPG（1）还是shc（2）？"
        read choose
        case $choose in
            1)
                command -v gpg >/dev/null || { echo "未安装gpg"; exit 1; }
                echo "请选择加密（1）还是解密（2）脚本"
                read input
                case $input in
                    1)
                        gpg -c "$path"
                        ;;
                    2)
                        filename="${path##*/}"
                        gpg "$filename"
                        ;;
                esac
                ;;
            2)
                echo "请选择加密（1）还是解密（2）脚本"
                read input
                case $input in
                    1)
                        shc -f "$path" -o "$path"
                        echo "加密完成 -> $path，由于特殊限制，必须要将此脚本移动到home"
                        echo "你的系统是否有此限制？有输入y，没有输入n，不确定输入u尝试"
                        read choose
                        case $choose in
                            y|Y)
                                cp "$path" "$HOME/storage/"
                                rm -f "$path"
                                echo "文件保存到~/storage"
                                echo "是否执行此文件[y]？不是请回车"
                                read input
                                filename=$(basename "$path")
                                [ "$input" = "y" ] && cd ~/storage && chmod +x "$filename"
                                ;;
                            n|N)
                                echo "已知晓"
                                ;;
                            u|U)
                                cp "$path" "$HOME/storage/"
                                ;;
                        esac
                        ;;
                    2)
                        printf "请输入要解密的文件路径："
                        read path
                        ./unshc.sh "$path" -o "$path"
                        echo "解密完成，提示：如果显示 unshc 未找到，请自行查找unshc安装方法"
                        ;;
                esac
                ;;
        esac
        ;;
    14)
        printf "自我检查输入1，检查其他脚本输入2："
        read choose
        echo "无输出即正常"
        sleep 1
        case $choose in
            1)
                sh -n "$0"
                ;;
            2)
                printf "输入脚本路径："
                read path
                sh -n "$path"
                ;;
        esac
        ;;
    15)
        echo "请选择编码还是解码[1/2]"
        read input
        case $input in
            1)
                printf "请输入要编码的文本："
                read text
                echo -n "$text" | base64
                ;;
            2)
                printf "输入要解码的 base64："
                read text
                echo -n "$text" | base64 -d
                ;;
        esac
        ;;
   16)
        echo "说明：原理是将脚本开头插入输入密码的命令，然后用shc加密脚本"
        echo "请输入文件路径："
        read path
        echo "请输入访问密码："

        read passwd
        {
            echo 'echo "请先输入密码："'
            echo 'read p'
            echo "if [ \"\$p\" = \"$passwd\" ]; then"
            echo '  echo "密码正确"'
            echo 'else'
            echo '  echo "密码错误"'
            echo '  exit 1'
            echo 'fi'
        } > insert.txt
        sed -e '1r insert.txt' "$path" > tmp && mv tmp "$path"
        rm -f insert.txt
        shc -f "$path" -o "$path"
        echo "隐藏完成，由于特殊限制，需要将此文件移动到home"
        echo "你的系统是否有此限制？[Y/n]如果不确定输入u尝试能否正常执行"
        read choose
        case $choose in
            y|Y)
                cp "$path" "$HOME/storage/"
                rm -f "$path"
                echo "文件保存到~/storage"
                echo "是否执行此文件[y]？不是请回车退出"
                read input
                filename=$(basename "$path")
                [ "$input" = "y" ] && cd ~/storage && chmod +x "$filename"
                ;;
            n|N)
                echo "吾已知晓"
                ;;
            u|U)
                cp "$path" "$HOME/storage/"
                ;;
        esac
        ;;
    17)
        pkg update
        pkg install -y bash dash zsh fish tcsh mksh elvish
        ;;
    18)
	echo "请输入IP地址（默认为本机IP）"
	read input
	if [ "$input" = "" ]; then
	  input="ip.sb"
	fi
        curl -s "http://ip-api.com/json/$(curl -s $input)" \
     --data-urlencode "lang=zh-CN" \
     --data-urlencode "fields=status,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,query" \
| jq '
{
    "公网IP": .query,
    "状态": (.status | sub("success"; "成功" | sub("fali"; "失败"))),
    "国家": (.country | sub("China"; "中国")),
    "省份": .regionName,
    "城市": .city,
    "邮编": .zip,
    "纬度": .lat,
    "经度": .lon,
    "时区": (.timezone | sub("Asia/Shanghai"; "亚洲/上海")),
    "运营商": .isp,
    "组织": .org,
    "ASN": .as
'}
        ;;
    19)
	printf "类别字母(默认随机): "; read -r TYPE
printf "要输出几句？（默认1句）: "; read -r COUNT
TYPE=${TYPE:-""}
COUNT=${COUNT:-1}
case $COUNT in ''|*[!0-9]*) COUNT=1 ;; esac

URL="https://international.v1.hitokoto.cn/?c=${TYPE}&encode=json"

echo "获取一般需要15s以下，并且有可能会失败"
printf "\n正在获取 %d 句 …\n" "$COUNT" >&2
RESULT=""
i=1
while [ "$i" -le "$COUNT" ]; do
  printf "\r进度 %d/%d" "$i" "$COUNT" >&2
  RAW=$(curl -sf --max-time 20 "$URL" 2>/dev/null)
  if [ -n "$RAW" ]; then
    H=$(printf '%s\n' "$RAW" | awk -F'"hitokoto":"' '{print $2}' | cut -d'"' -f1)
    F=$(printf '%s\n' "$RAW" | awk -F'"from":"'    '{print $2}' | cut -d'"' -f1)
    RESULT="$RESULT「$H」——《$F》"
    i=$((i+1))
  fi
done
printf "\r\033[K" >&2
printf "%s" "$RESULT"
	;;
    h|H|help|-h|--help|-H)
        echo -n "${CYAN}版本：正式版2.4 ${BLUE}更新日志：添加颜色${N}\n"
        echo "开发者qq号：3848641515，电子邮箱：wangxia9@foxmail.com，备用tong689@outlook.com，不懂问我"
	echo "可能会有某些功能需要安装特定的软件包，缺啥补啥就行"
	echo "在使用某些功能时，链接可能会失效，麻烦及时反馈给我"
	echo "h|H|help|-h|--help|-H)"
	echo "统一指向帮助界面（此界面）"
	echo "*)\n退出脚本，也可以使用选项0强制退出脚本"
        ;;
    *)
        if [ "$choice" = "" ]; then
            exit 0
        else
            echo -n "${RED}ERROR: $choice: 选项未找到${N}\n"
        fi
        ;;
esac
