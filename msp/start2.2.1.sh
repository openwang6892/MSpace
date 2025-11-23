#!/system/bin/sh
clear
echo "==== Termux 启动菜单 ===="
echo "$0"
echo "0.安装必要软件包"
echo "1.启动 NetHunter"
echo "2.启动 VNC 服务器"
echo "3.启动 ADB 服务"
echo "4.搜索文件"
echo "5.编辑~/.bashrc"
echo "6.编辑此脚本"
echo "7.备份~/.bashrc或此脚本"
echo "8.获取~/.bashrc理想的内容(应该覆盖文件)"
echo "9.获取termux原版启动页"
echo "10.添加命令"
echo "11.尝试调用tmoe"
echo "12.启动python静态文件服务器"
echo "13.使用shc/unshc加解密脚本"
echo "14.检查脚本是否有错"
echo "15.使用base64编解码文本"
echo "h.获取帮助"
echo "*.退出"
echo "========================"
printf "请输入选项："
read choice

case $choice in
    0)
        echo "如果要安装的话，会占用内存，时间，存储空间，安装请按回车"
        read input
        pkg install git gcc curl wget python
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
        echo "搜索中..."
        i=1
        find / -type f -name "*.sh" 2>/dev/null | while IFS= read -r file; do
            echo "$i) $file"
            i=$((i+1))
        done > /tmp/shlist
        cat /tmp/shlist
        printf "请输入脚本编号："
        read num
        file=$(sed -n "${num}p" /tmp/shlist | cut -d')' -f2- | xargs)
        [ -n "$file" ] && sh "$file"
        rm -f /tmp/shlist
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
                echo "已全部备份到 /sdcard/"
		echo "去掉后缀名.bak即可查看备份"
                ;;
            *)
                echo "退出"
                ;;
        esac
        ;;
    8)
        echo '# 登录时自动跑一次
sh starter.sh

# 以后想再跑，就输入menu
alias menu="sh ~/starter.sh"'
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
                echo "加密完成 -> $out"
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
                    echo "cd ~ && pkg install git gcc && git clone https://github.com/yanncam/UnSHc.git && cd UnSHc && make"
                else
                    exit 0
                fi
                ;;
        esac
        ;;
    14)
        printf "自我检查输入1，检查其他脚本输入2："
        read choose
        echo "运行后按 Ctrl+C 退出，无输出即正常"
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
    h)
        echo "版本：正式版2.2.1 更新日志：隐藏小改动"
        echo "开发者qq号：3848641515，电子邮箱：wangxia9@foxmail.com，备用tong689@outlook.com，不懂问我"
        ;;
    *)
	if [ "$choose" = "" ]; then
	echo "无输入"
	exit 0
	echo "ERROR: start: $choose: 选项未找到"
	exit 1
        fi
        ;;
esac
