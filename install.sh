set -eo pipefail
repo="openwang6892/MSpace"
proxy="https://gh-proxy.org"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
die(){ echo "${_bold}${_red}[ERROR]${_reset} $*" >&2; exit 1; }
log(){ echo "${_bold}${_green}[INFO]${_reset} $*"; }
command -v tput &>/dev/null||pkg i ncurses-utils||die "安装失败"
_red=$(tput setaf 1) _green=$(tput setaf 2) _yellow=$(tput setaf 3) _bold=$(tput bold) _reset=$(tput sgr0)
need=(curl wget jq)
for p in "${need[@]}"; do
  command -v "$p" &>/dev/null && continue
  read -rp "缺失 $p，是否立即安装? [Y/n] " c
  [[ $c =~ ^[Nn]$ ]] && exit 1
  pkg install "$p" -y || die "$p 安装失败"
done
TMP_DIR=$(mktemp -d "$PREFIX/tmp/msp_install.XXXXXX")
trap "rm -rf '$TMP_DIR'" EXIT
log "获取最新版本信息 ..."
LATEST=$(curl -s "$proxy/api.github.com/repos/$repo/releases/latest" | grep -oP '"tag_name": "\K[^"]+') || die "无法获取，请重试"
BASE="$proxy/github.com/$repo/releases/download/${LATEST}"
raw_base="$proxy/raw.githubusercontent.com/$repo/refs/heads/main"
log "版本号：${LATEST}"
read -rp "是否安装？是请回车："
log "下载 msp 与 color.conf ..."
cd "$TMP_DIR"
wget -q --show-progress "$BASE/msp" || die "下载 msp 失败"
curl -# -o color.conf "$raw_base/color.conf" || die "下载 color.conf 失败"
log "开始安装 ..."
mkdir -p "$HOME/.mspconf"
install -Dm644 color.conf "$HOME/.mspconf/color.conf"
read -rp "安装 msp 的目标目录（回车使用 \$PREFIX/bin）： " DEST
DEST="${DEST:-$PREFIX/bin}"
mkdir -p "$DEST"
install -Dm755 msp "$DEST/msp"
log "安装完成！执行 ${_bold}msp${_reset} 即可开始使用"