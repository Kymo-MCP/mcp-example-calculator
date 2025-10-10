#!/bin/bash
set -euo pipefail

# ==============================
# 传入参数：指定 dxt 文件路径
# ==============================
DXT_FILE="${1:-}"
if [ -z "$DXT_FILE" ]; then
  echo "用法: $0 <path_to_dxt_file>"
  exit 1
fi

# 自动提取文件名作为解压目录
BASENAME=$(basename "$DXT_FILE" .dxt)
EXTRACT_TO="${BASENAME}_extracted"

# ==============================
# 日志函数
# ==============================
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $*"
}
log_error() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" >&2
}

# ==============================
# 依赖检查
# ==============================
command -v jq >/dev/null 2>&1 || { log_error "需要 jq，请先安装：sudo apt install jq -y"; exit 1; }
command -v unzip >/dev/null 2>&1 || { log_error "需要 unzip，请先安装：sudo apt install unzip -y"; exit 1; }

# ==============================
# 1. 解压
# ==============================
if [ ! -f "$DXT_FILE" ]; then
  log_error "未找到文件: $DXT_FILE"
  exit 1
fi

rm -rf "$EXTRACT_TO"
mkdir -p "$EXTRACT_TO"

log "正在解压: $DXT_FILE -> $EXTRACT_TO"
unzip -o "$DXT_FILE" -d "$EXTRACT_TO" >/dev/null
log "✅ 解压完成"

# ==============================
# 2. 获取 entry_point 并计算绝对路径
# ==============================
MANIFEST_PATH="$EXTRACT_TO/manifest.json"
if [ ! -f "$MANIFEST_PATH" ]; then
  log_error "未找到 manifest.json"
  exit 1
fi

ENTRYPOINT_REL=$(jq -r '.server.entry_point' "$MANIFEST_PATH")
if [ -z "$ENTRYPOINT_REL" ] || [ "$ENTRYPOINT_REL" = "null" ]; then
  log_error "manifest.json 中缺少 server.entry_point"
  exit 1
fi

ENTRYPOINT_ABS="$(realpath "$EXTRACT_TO/$ENTRYPOINT_REL")"
if [ ! -f "$ENTRYPOINT_ABS" ]; then
  log_error "入口文件不存在: $ENTRYPOINT_ABS"
  exit 1
fi

# 授权执行权限
chmod 755 "$ENTRYPOINT_ABS"
log "入口文件: $ENTRYPOINT_ABS"
log "已授予执行权限 (chmod 755)"

# ==============================
# 3. 修复 venv 下的 python 权限
# ==============================
VENVBIN="$EXTRACT_TO/server/venv/bin"
if [ -d "$VENVBIN" ]; then
  for f in "$VENVBIN"/python*; do
    [ -f "$f" ] || continue
    chmod +x "$f"
    log "修复执行权限: $f"
  done
else
  log "未检测到 venv 目录，跳过虚拟环境修复"
fi

# ==============================
# 4. 获取 site-packages
# ==============================
SITE_PACKAGES=$(find "$EXTRACT_TO/server/venv/lib" -type d -name "site-packages" | head -n1 || true)
if [ -z "$SITE_PACKAGES" ]; then
  log_error "未找到 site-packages"
  exit 1
fi
SITE_PACKAGES=$(realpath "$SITE_PACKAGES")
log "site-packages 路径: $SITE_PACKAGES"

# ==============================
# 5. 启动 MCP 服务
# ==============================
PYTHON_BIN=$(ls "$VENVBIN"/python* | sort | head -n2 | tail -n1)
log "使用 Python 解释器: $PYTHON_BIN"
log "🚀 启动 MCP 服务中..."
exec env PYTHONPATH="$SITE_PACKAGES" "$PYTHON_BIN" "$ENTRYPOINT_ABS"
