#!/bin/bash
set -euo pipefail

# ===== 参数检查 =====
DXT_FILE="${1:-}"
if [ -z "$DXT_FILE" ]; then
  echo "用法: $0 <path_to_dxt_file>"
  exit 1
fi

# ===== 变量设置 =====
ZIP_FILE="$DXT_FILE"
EXTRACT_DIR="${DXT_FILE%.dxt}_extracted"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $*"
}
log_error() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" >&2
}

# ===== 检查依赖 =====
command -v unzip >/dev/null 2>&1 || { log_error "缺少 unzip，请先安装"; exit 1; }
command -v jq >/dev/null 2>&1 || { log_error "缺少 jq，请先安装"; exit 1; }

# ===== 1. 解压 zip 文件 =====
if [ ! -f "$ZIP_FILE" ]; then
  log_error "未找到文件: $ZIP_FILE"
  exit 1
fi

log "正在解压 $ZIP_FILE ..."
rm -rf "$EXTRACT_DIR"
unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR" >/dev/null
log "解压完成 -> $EXTRACT_DIR"

# ===== 2. 读取 manifest.json，获取 entry_point =====
MANIFEST_PATH="$EXTRACT_DIR/manifest.json"
if [ ! -f "$MANIFEST_PATH" ]; then
  log_error "未找到 manifest.json"
  exit 1
fi

ENTRY_POINT=$(jq -r '.server.entry_point // empty' "$MANIFEST_PATH")
if [ -z "$ENTRY_POINT" ]; then
  log_error "manifest.json 中未找到 server.entry_point"
  exit 1
fi

# ===== 3. 拼接绝对路径 =====
ABS_DIR=$(cd "$EXTRACT_DIR" && pwd)
SERVER_PATH="$ABS_DIR/$ENTRY_POINT"

if [ ! -f "$SERVER_PATH" ]; then
  log_error "入口文件不存在: $SERVER_PATH"
  exit 1
fi

# ===== 4. 授予执行权限 =====
log "为可执行文件设置权限: chmod 755 $SERVER_PATH"
chmod 755 "$SERVER_PATH"

log "Node MCP 入口文件绝对路径："
echo "$SERVER_PATH"

# ===== 5. 检查并安装依赖 =====
if [ -f "$EXTRACT_DIR/package.json" ]; then
  log "检测到 package.json，执行 npm install ..."
  (cd "$EXTRACT_DIR" && npm install --silent)
fi

# ===== 6. 启动 Node MCP 服务 =====
log "启动 Node MCP 服务..."
cd "$EXTRACT_DIR"
node "$SERVER_PATH"
