#!/bin/sh

clear
echo "==== Termux 启动菜单 ===="
echo "$0"
echo "0.强制退出菜单"
echo "1.启动 NetHunter"
echo "2.启动 VNC 服务器"
echo "3.启动 ADB 服务"
echo "4.一键打包GKD订阅"
echo "5.编辑~/.bashrc"
echo "6.编辑此脚本"
echo "7.备份~/.bashrc或此脚本"
echo "8.管理提醒"
echo "9.获取termux原版启动页"
echo "10.添加命令"
echo "11.尝试调用tmoe"
echo "12.启动python静态文件服务器"
echo "13.使用shc/unshc加解密脚本"
echo "14.检查脚本是否有错"
echo "15.使用base64编解码文本"
echo "16.生成隐私脚本"
echo "17.错误检查一条龙"
echo "h.获取帮助"
echo "*.退出"
echo "========================"
printf "请输入选项："
read choice

case $choice in
    0)
        exit 2
        ;;
    1)
        nethunter
        ;;
    2)
        startvnc
        ;;
    3)
        adb start-server
        ;;
    4)
	#ZnVjayBBbmRyb2lk
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
        case "$input" in
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
	cd $path
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
        curl -L https://gitee.com/mo2/linux/raw/2/2 | sh
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
        echo "请选择加密（1）还是解密（2）脚本"
        read input
        case $input in
            1)
                printf "请输入要加密的文件路径："
                read path
                printf "加密后输出路径（默认覆盖原文件）："
                read out
                out=${out:-$path}
                shc -f "$path" -o "$out"
                echo "加密完成 -> $out，由于特殊限制，必须把脚本移动到Home才能执行"
		echo "你的系统是否有此限制？[Y/n]如果不确定输入u尝试能否正常运行"
	        read choose
        	case $choose in
	        y|Y)
        	     cp $path $HOME/storage/
	             rm -f $path
	             echo "文件保存到~/storage"
	             echo "是否执行此文件[y]？不是请回车退出"
	             read input
	             filename=$(basename "$path")
	             if [ "$input" = "y" ]; then
	               cd ~/storage && chmod +x $filename && ./$filename
	             fi
	             ;;
	        n|N)
	             echo "已知晓"
	             ;;
	        u|U)
	             cp $path $HOME/storage/
        	     ;;
	        esac
                ;;
            2)
                printf "请输入要解密的文件路径："
                read path
                printf "解密后输出路径（默认覆盖原文件）："
                read out
                out=${out:-$path}
                ./unshc.sh "$path" -o "$out"
                echo "解密完成，提示：如果显示 unshc 未找到，请输入 help 获取帮助，回车退出脚本"
                read input
                if [ "$input" = "help" ]; then
                    echo "粘贴以下命令到 termux："
                    echo "cd ~ && pkg install git clang && git clone https://github.com/yanncam/UnSHc.git && cd UnSHc && make"
                else
                    exit 0
                fi
                ;;
        esac
        ;;
    14)
        printf "自我检查输入1，检查其他脚本输入2："
        read choose
        echo "无输出即正常"
        sleep 1
        case $choose in
            1) sh -n "$0" ;;
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
	echo "说明：原理是将脚本开头插入输入密码的命令，然后用shc加密脚本，这样别人无法看到脚本内容，要执行要先输入密码"
	echo "请输入文件路径："
	read path
	echo "请输入访问密码："
	read passwd
	touch insert.txt
	cat > insert.txt <<'IN'
	echo "请先输入密码："
        read passwd
        if [ "$passwd" = "1" ]; then
          echo "密码正确"
        else
          echo "密码错误"
          exit 1
        fi
IN

	sed -e '1r insert.txt' $path > tmp && mv tmp $path
	rm -f insert.txt
	shc -f "$path" -o "$path"
        echo "隐藏完成，由于特殊限制，需要将此文件移动到home才行能避开权限不足"
	echo "你的系统是否有此限制？[Y/n]如果不确定输入u尝试能否正常执行"
	read choose
	case $choose in
	y|Y)
	     cp $path $HOME/storage/
	     rm -f $path
	     echo "文件保存到~/storage"
	     echo "是否执行此文件[y]？不是请回车退出"
	     read input
	     filename=$(basename "$path")
	     if [ "$input" = "y" ]; then
	       cd ~/storage && chmod +x $filename && ./$filename
	     fi
	     ;;
	n|N)
	     echo "吾已知晓"
	     ;;
	u|U)
	     cp $path $HOME/storage/
	     ;;
	esac
	;;
   17)
	echo "请输入要检查的脚本路径（自我检查输入0)"
	read path
	if [ "$path" = "0" ]; then
	  sed -i 's/path/path=$($0)/' $0
	fi
	echo "有输出即错误"
	grep -n "^[^']*'[^']*$" $path
  	grep -n '^[^"]*"[^"]*$' $path
        grep -n '^[^`]*`[^`]*$' $path
        awk -F'[()]' 'NF && (NF-1)%2 {print NR ": " $0}' $path
        awk -F'[{}]' 'NF && (NF-1)%2 {print NR ": " $0}' $path
        awk -F'[][]' 'NF && (NF-1)%2 {print NR ": " $0}' $path
        awk '
        /<<[-]?["'\'']?EOF["'\'']?/ {f=1}
        f && /^[[:space:]]*[^[:space:]]+[[:space:]]*$/ && $0 !~ /^EOF$/ {print NR ": " $0}
        /^EOF$/ {f=0}
        ' $path
        sh -n $path && echo "OK" || echo "ERROR"
	;;
    h|H|help)
        echo "版本：正式版2.4 更新日志：增改选项"
        echo "开发者qq号：3848641515，电子邮箱：wangxia9@foxmail.com，备用tong689@outlook.com，不懂问我"
        ;;
    *)
	echo "start: $choice: 选项未找到"
        ;;
esac
