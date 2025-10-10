#!/bin/bash
set -euo pipefail

# ======= 配置 =======
DXT_FILE="${1:-}"
if [ -z "$DXT_FILE" ]; then
  echo "用法: $0 <path_to_dxt_file>"
  exit 1
fi

# 检查依赖
command -v jq >/dev/null 2>&1 || { echo "❌ 需要 jq，请先安装：sudo apt install jq"; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "❌ 需要 unzip，请先安装：sudo apt install unzip"; exit 1; }

# ======= 1. 解压 dxt 文件 =======
EXTRACT_DIR="${DXT_FILE%.dxt}_extracted"
echo "📦 解压到: $EXTRACT_DIR"
rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"
unzip -q "$DXT_FILE" -d "$EXTRACT_DIR"

# ======= 2. 解析 manifest.json 中的 entry_point =======
MANIFEST_PATH="$EXTRACT_DIR/manifest.json"
if [ ! -f "$MANIFEST_PATH" ]; then
  echo "❌ 未找到 manifest.json"
  exit 1
fi

ENTRY_POINT_REL=$(jq -r '.server.entry_point' "$MANIFEST_PATH")
if [ "$ENTRY_POINT_REL" = "null" ] || [ -z "$ENTRY_POINT_REL" ]; then
  echo "❌ manifest.json 中未定义 server.entry_point"
  exit 1
fi

# 转换为绝对路径
ENTRY_POINT_ABS="$(realpath "$EXTRACT_DIR/$ENTRY_POINT_REL")"
if [ ! -f "$ENTRY_POINT_ABS" ]; then
  echo "❌ 找不到可执行文件: $ENTRY_POINT_ABS"
  exit 1
fi

# ======= 3. 设置执行权限 =======
echo "🔧 设置执行权限: chmod 755 $ENTRY_POINT_ABS"
chmod 755 "$ENTRY_POINT_ABS"

# ======= 4. 执行二进制文件 =======
echo "🚀 即将执行: $ENTRY_POINT_ABS"
echo "--------------------------------"
"$ENTRY_POINT_ABS"

