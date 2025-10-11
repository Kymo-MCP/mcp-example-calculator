#!/bin/sh
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
for dep in jq unzip; do
  command -v $dep >/dev/null 2>&1 || { log_error "需要 $dep，请先安装"; exit 1; }
done

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
# 2. 读取 manifest.json
# ==============================
MANIFEST_PATH="$EXTRACT_TO/manifest.json"
if [ ! -f "$MANIFEST_PATH" ]; then
  log_error "未找到 manifest.json"
  exit 1
fi

SERVER_TYPE=$(jq -r '.server.type' "$MANIFEST_PATH")
ENTRYPOINT_REL=$(jq -r '.server.entry_point' "$MANIFEST_PATH")
COMMAND=$(jq -r '.server.mcp_config.command // empty' "$MANIFEST_PATH")
ARGS=$(jq -r '.server.mcp_config.args | join(" ") // empty' "$MANIFEST_PATH")

if [ -z "$SERVER_TYPE" ] || [ "$SERVER_TYPE" = "null" ]; then
  log_error "manifest.json 中缺少 server.type"
  exit 1
fi
if [ -z "$ENTRYPOINT_REL" ] || [ "$ENTRYPOINT_REL" = "null" ]; then
  log_error "manifest.json 中缺少 server.entry_point"
  exit 1
fi

ENTRYPOINT_ABS="$(realpath "$EXTRACT_TO/$ENTRYPOINT_REL")"
if [ ! -f "$ENTRYPOINT_ABS" ]; then
  log_error "入口文件不存在: $ENTRYPOINT_ABS"
  exit 1
fi

log "服务类型: $SERVER_TYPE"
log "入口文件: $ENTRYPOINT_ABS"

# ==============================
# 3. 启动逻辑分支
# ==============================
case "$SERVER_TYPE" in
  # ---------- Python ----------
  python)
    log "🐍 Python MCP 模式启动"

    VENVBIN="$EXTRACT_TO/server/venv/bin"
    if [ -d "$VENVBIN" ]; then
      log "检测到虚拟环境，修复 Python 可执行权限"
      for f in "$VENVBIN"/python*; do
        [ -f "$f" ] || continue
        chmod +x "$f"
        log "修复执行权限: $f"
      done
    else
      log "未检测到 venv 目录，跳过虚拟环境修复"
    fi

    # 找到 site-packages
    SITE_PACKAGES=$(find "$EXTRACT_TO/server/venv/lib" -type d -name "site-packages" | head -n1 || true)
    if [ -z "$SITE_PACKAGES" ]; then
      log_error "未找到 site-packages，可能 venv 不完整"
      exit 1
    fi
    SITE_PACKAGES=$(realpath "$SITE_PACKAGES")
    log "site-packages 路径: $SITE_PACKAGES"

    # 找 Python 解释器
    PYTHON_BIN=$(ls "$VENVBIN"/python* 2>/dev/null | sort | head -n2 | tail -n1 || true)
    if [ -z "$PYTHON_BIN" ]; then
      log_error "未找到 venv 中的 Python 解释器"
      exit 1
    fi

    log "使用 Python 解释器: $PYTHON_BIN"
    log "🚀 启动 MCP 服务中..."
    exec env PYTHONPATH="$SITE_PACKAGES" "$PYTHON_BIN" "$ENTRYPOINT_ABS"
    ;;

  # ---------- Node.js ----------
  node)
    log "🟢 Node.js MCP 模式启动"

    cd "$EXTRACT_TO"
    if [ -f "package.json" ]; then
      log "检测到 package.json，执行 npm install ..."
      npm install --silent
    fi

    ARGS=${ARGS//\$\{__dirname\}/$(pwd)}
    CMD="$COMMAND $ARGS"

    log "执行命令: $CMD"
    eval "$CMD"
    ;;

  # ---------- Binary ----------
  binary)
    log "⚙️ Binary MCP 模式启动"
    CMD="${COMMAND//\$\{__dirname\}/$(realpath "$EXTRACT_TO")}"
    chmod +x "$CMD"
    log "执行命令: $CMD $ARGS"
    cd "$EXTRACT_TO"
    eval "$CMD $ARGS"
    ;;

  # ---------- 未知 ----------
  *)
    log_error "未知 server.type: $SERVER_TYPE"
    exit 1
    ;;
esac


