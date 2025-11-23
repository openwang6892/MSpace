#!/data/data/com.termux/files/usr/bin/bash
clear
echo "==== Termux 启动菜单 ===="
echo "$0"
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
echo "13.使用shc加密脚本"
echo "14.检查脚本是否有错"
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
       search_sh_files() {
    # 使用find命令搜索设备上所有的.sh文件
    find / -type f -name "*.sh" 2>/dev/null
}

# 定义一个函数，用于显示case菜单
show_menu() {
    echo "请选择要执行的脚本："
    echo "-----------------------------------"
    # 调用search_sh_files函数，将搜索到的.sh文件存储到一个数组中
    mapfile -t sh_files < <(search_sh_files)
    # 遍历数组，显示脚本编号和脚本路径
    for i in "${!sh_files[@]}"; do
        echo "$((i+1)). ${sh_files[$i]}"
    done
    echo "-----------------------------------"
    echo "请输入脚本编号："
}

# 定义一个函数，用于执行用户选择的脚本
execute_script() {
    # 获取用户输入的脚本编号
    read -p "请输入脚本编号： " script_num
    # 判断用户输入的编号是否有效
    if [[ "$script_num" =~ ^[0-9]+$ ]] && (( script_num > 0 && script_num <= ${#sh_files[@]} )); then
        # 获取用户选择的脚本路径
        selected_script="${sh_files[$((script_num-1))]}"
        # 执行用户选择的脚本
        bash "$selected_script"
    else
        echo "无效的脚本编号！"
    fi
}

# 主程序
while true; do
    # 显示case菜单
    show_menu
    # 执行用户选择的脚本
    execute_script
    # 提示用户是否继续
    read -p "是否继续？(y/n): " choice
    if [[ "$choice" != "y" ]]; then
        break
    fi
done
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
    10)
        echo "输入命令名称："
        read command
        echo "输入此命令将会执行什么："
        read command_run
        echo "alias $command=\"$command_run\"" >> ~/.bashrc
	source ~/.bashrc
        echo "已尝试添加"
        ;;
    11)
        curl -L gitee.com/mo2/linux/raw/2/2 | sh
        ;;
    12)
        echo "输入一个4位数端口号："
        read port
        echo "输入服务器将会访问的路径："
  	read path
        cd $path
        echo "输入localhost:$port 在浏览器即可访问"
        python -m http.server $port
        ;;
   13)
	echo "请输入要加密的文件地址："
        read path
        echo "请输入加密后的文件地址（可选）："
        read output
        if [ "$output" = "" ]; then
       	  shc -f $path -o $path
        else
          shc -f $path -o $output
        fi
        ;;
   14)
	echo "自我检查输入1，检查其他脚本输入2"
        read choose
        echo "运行脚本后按Ctrl C退出，如果没有任何输出就代表正常"
	sleep 1
        case $choose in
        1)
	    bash -m $0
	    ;;
        2)
   	    echo "输入要检查的文件路径"
 	    read path
	    bash -m $path
            ;;
        esac
        ;;
    h)
	echo "版本：正式版1.4"
        echo "开发者qq号：3848641515，电子邮箱：wangxia9@foxmail.com，备用tong689@outlook.com，不懂问我"
        ;;
    *)
        echo "exit"
        ;;
esac
