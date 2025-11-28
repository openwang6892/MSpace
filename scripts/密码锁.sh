#!/usr/bin/env bash
# 关掉回显
trap "stty echo" EXIT

# 读密码函数
pw() {
   local var=$1 char
   unset "$var"
   while IFS= read -r -n1 -s char; do
      # Enter 结束
      [[ $char == $'' || $char == $'\r' ]] && break
      # Backspace / DEL
      if [[ $char == $'\x7f' || $char == $'\x08' ]]; then
         if [[ ${!var} ]]; then # 变量非空才删
            # 临时打开回显，清掉一个 '*'
            stty echo
            printf '\b \b'
            stty -echo
            # 去掉最后一个字符
            printf -v "$var" '%s' "${!var%?}"
         fi
         continue
      fi
      # 普通字符
      printf '*'
      printf -v "$var" '%s' "${!var}$char"
   done
   echo
}

check_pass() {
   stty -echo
   printf "请输入密码："
   pw pass2
   inputHash=$(echo -n "${pass2}" | sha256sum | awk '{print $1}')
   if [[ $inputHash == "$(<"$file")" ]]; then
      echo -e "密码正确"
      echo "SUC：$time：密码输入正确" >>$log
      return 0
   else
      echo -e "密码错误\n"
      echo "ERR：$time：密码输入错误" >>$log
      [ -z "$1" ] && bash "$0"
   fi
}

time=$(date '+%F %T')

# 文件路径
file="$HOME/.config/password/hash"
path=$(dirname "$file")
log="$path/login.log"
mkdir -p "$path"
[ -f "$log" ] || touch $log

# 日志变量
log1=$(awk 'END{print NR}' $log)
try_suc=$(grep -c 'SUC' $log)
try_err=$(grep -c 'ERR' $log)
log_info=$(grep -c 'INFO' $log)
login_try=$((log1 - log_info))

[ -z "$1" ] || exit 0
# 第一次使用：让用户设密码
if [[ ! -f $file ]]; then
   printf "首次运行，请设定密码："
   pw pass1
   echo -n "${pass1}" | sha256sum | awk '{print $1}' >"$file"
   echo "密码已保存"
   echo "请保管好您的密码，它将再也不会显示：$pass1"
   read -p "按 Enter 继续... " enter
   clear
fi

echo "1.查看日志"
echo "2.查看密码哈希"
echo "3.清空日志"
echo "4.操作统计"
echo "5.重启（将会注销所有操作）"
echo "0.登录 login"
echo "*.退出"

read -p "请输入选项：" choice
case $choice in
   1) cat $log ;;
   2) cat $file || echo "INFO：$time：密码文件不存在" >$log ;;
   3) >$log && echo "已清空日志" ;;
   4) echo "累计$try_err次登录失败\n$try_suc成功\n$log_info次其他信息\n一共$login_try次登录信息\n一共$try条信息" ;;
   5)
      echo "正在执行重启操作，先验证密码"
      check_pass 1
      rm -rf "$path" &>/dev/null || {
         echo "已经重启过了"
         exit 1
      }
      echo "已重启"
      ;;
   0) check_pass ;;
   *) exit 0 ;;
esac