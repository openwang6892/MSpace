> sha256.txt
for f in msp/*; do
    [[ -f $f ]] || continue  # 跳过目录
    sha256sum < "$f"         # 输出“哈希 + 两个空格”
done | cut -d' ' -f1 > sha256.txt