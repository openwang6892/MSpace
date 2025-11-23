#!/data/data/com.termux/files/usr/bin/bash
clear
echo "==== Termux 启动菜单 ===="
echo "运行nano $0来编辑此脚本"
echo "1.启动 NetHunter"
echo "2.启动 VNC 服务器"
echo "3.启动 ADB 服务"
echo "4.获取脚本路径"
echo "5.编辑~/.bashrc"
echo "6.编辑此脚本"
echo "7.备份~/.bashrc或此脚本"
echo "8.获取~/.bashrc理想的内容(应该覆盖文件)"
echo "9.获取termux原版启动页"
echo "h.获取帮助"
echo "*.退出"
echo "========================"
read -p "请输入选项：" choice

case $choice in
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
        echo "$0"
        ;;
    5)
        nano ~/.bashrc
        ;;
    6)
        nano ~/starter.sh
        ;;
    7)
        echo "备份~/.bashrc请输入B，备份此脚本请输入S，全部备份请输入all"
        read input
        case "$input" in
  B|b)
    cp ~/.bashrc "$HOME/storage/shared/"
    ;;
  S|s)
    cp "$0" "$HOME/storage/shared/"
    ;;
  all|All|ALL)
    cp "$0" "$HOME/storage/shared/"
    cp ~/.bashrc "$HOME/storage/shared/"
    ;;
  *)
    echo "exit"
    ;;
        esac
       echo "保存在/sdcard/"
        ;;
    8)
       echo "# 登录时自动跑一次
sh starter.sh

# 以后想再跑，就输入menu
alias menu=sh ~/starter.sh"
        ;;
    9)
        echo "Welcome to Termux!

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

Report issues at https://termux.dev/issues"
        ;;
    h)
        echo "开发者qq号：3848641515，电子邮箱：wangxia9@foxmail.com，备用tong689@outlook.com，不懂问我"
        ;;
    *)
        echo "exit"
        ;;
esac
