#!/bin/bash

# MCP Calculator Service 打包脚本
# 将Python程序打包为zip文件，便于在Linux服务器上快速部署

set -e

# 配置变量
project_name="mcp-calculator-service"
build_dir="build"
package_name="${project_name}.zip"

# 清理旧的构建文件
echo "清理旧的构建文件..."
rm -rf "${build_dir}"
rm -f "${package_name}"

# 创建构建目录
echo "创建构建目录..."
mkdir -p "${build_dir}"

# 复制必要文件到构建目录
echo "复制项目文件..."
cp main.py "${build_dir}/"
cp requirements.txt "${build_dir}/"
cp manifest.json "${build_dir}/"

# 创建启动脚本
echo "创建启动脚本..."
cat > "${build_dir}/start.sh" << 'EOF'
#!/bin/bash

# MCP Calculator Service 启动脚本

set -e

echo "正在启动 MCP Calculator Service..."

# 检查Python环境
if ! command -v python3 &> /dev/null; then
    echo "错误: 未找到 python3，请先安装 Python 3"
    exit 1
fi

# 安装依赖
echo "安装Python依赖..."
pip3 install -r requirements.txt

# 启动服务
echo "启动计算器服务..."
python3 main.py
EOF

# 设置启动脚本执行权限
chmod +x "${build_dir}/start.sh"

# 创建README文件
echo "创建部署说明..."
cat > "${build_dir}/README.md" << 'EOF'
# MCP Calculator Service 部署包

## 快速启动

1. 解压zip文件到目标目录
2. 进入解压后的目录
3. 运行启动脚本：
   ```bash
   ./start.sh
   ```

## 系统要求

- Python 3.7+
- pip3

## 服务信息

- 服务名称: MCP Calculator Service
- 默认端口: 9001
- 主机地址: 0.0.0.0

## 手动启动

如果启动脚本无法使用，可以手动执行：

```bash
pip3 install -r requirements.txt
python3 main.py
```
EOF

# 打包为zip文件
echo "打包为zip文件..."
cd "${build_dir}"
zip -r "../${package_name}" .
cd ..

# 清理构建目录
echo "清理构建目录..."
rm -rf "${build_dir}"

echo "打包完成！"
echo "输出文件: ${package_name}"
echo "文件大小: $(du -h "${package_name}" | cut -f1)"
echo ""
echo "部署说明:"
echo "1. 将 ${package_name} 上传到Linux服务器"
echo "2. 解压: unzip ${package_name}"
echo "3. 进入目录并启动: ./start.sh"

# DXT/MCPB 打包脚本
# 用于将 MCP Calculator Service 打包为 .mcpb 文件

set -e  # 遇到错误时退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="mcp-calculator-service"
VERSION="1.0.0"
BUILD_DIR="build"
DIST_DIR="dist"

echo -e "${BLUE}🚀 开始构建 DXT/MCPB 扩展包...${NC}"

# 清理之前的构建
clean_build() {
    echo -e "${YELLOW}🧹 清理构建目录...${NC}"
    rm -rf "$BUILD_DIR"
    rm -rf "$DIST_DIR"
    rm -f *.mcpb
    rm -f *.dxt
}

# 创建构建目录
prepare_build() {
    echo -e "${YELLOW}📁 准备构建目录...${NC}"
    mkdir -p "$BUILD_DIR"
    mkdir -p "$DIST_DIR"
}

# 复制必要文件
copy_files() {
    echo -e "${YELLOW}📋 复制项目文件...${NC}"
    
    # 复制核心文件
    cp manifest.json "$BUILD_DIR/"
    cp main.py "$BUILD_DIR/"
    cp requirements.txt "$BUILD_DIR/"
    cp README.md "$BUILD_DIR/"
    
    # 如果存在其他必要文件，也复制过去
    if [ -f "mcpServers.json" ]; then
        cp mcpServers.json "$BUILD_DIR/"
    fi
    
    echo -e "${GREEN}✅ 文件复制完成${NC}"
}

# 安装Python依赖到构建目录
install_dependencies() {
    echo -e "${YELLOW}📦 安装Python依赖...${NC}"
    
    # 创建虚拟环境并安装依赖
    cd "$BUILD_DIR"
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    
    # 将依赖复制到lib目录
    mkdir -p lib
    cp -r venv/lib/python*/site-packages/* lib/
    
    # 清理虚拟环境
    rm -rf venv
    
    cd ..
    echo -e "${GREEN}✅ 依赖安装完成${NC}"
}

# 验证manifest.json
validate_manifest() {
    echo -e "${YELLOW}🔍 验证 manifest.json...${NC}"
    
    if ! python3 -c "
import json
import sys

try:
    with open('$BUILD_DIR/manifest.json', 'r') as f:
        manifest = json.load(f)
    
    required_fields = ['mcpb_version', 'name', 'version', 'description', 'runtime', 'entrypoint']
    missing_fields = [field for field in required_fields if field not in manifest]
    
    if missing_fields:
        print(f'错误: manifest.json 缺少必需字段: {missing_fields}')
        sys.exit(1)
    
    print('manifest.json 验证通过')
except Exception as e:
    print(f'错误: manifest.json 验证失败: {e}')
    sys.exit(1)
"; then
        echo -e "${RED}❌ manifest.json 验证失败${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ manifest.json 验证通过${NC}"
}

# 使用MCPB CLI打包
package_mcpb() {
    echo -e "${YELLOW}📦 使用 MCPB CLI 打包...${NC}"
    
    cd "$BUILD_DIR"
    
    # 使用mcpb pack命令打包
    if mcpb pack; then
        echo -e "${GREEN}✅ MCPB 打包成功${NC}"
        
        # 移动生成的文件到dist目录
        if [ -f "*.mcpb" ]; then
            # 生成MCPB格式
            mv *.mcpb "../$DIST_DIR/${PROJECT_NAME}-${VERSION}.mcpb"
            echo -e "${GREEN}📦 MCPB包已生成: ${PROJECT_NAME}-${VERSION}.mcpb${NC}"
        fi
    else
        echo -e "${RED}❌ MCPB 打包失败${NC}"
        cd ..
        exit 1
    fi
    
    cd ..
    
    # 为 DXT 格式创建专门的包
    echo -e "${YELLOW}🔄 生成 DXT 格式...${NC}"
    create_dxt_package
}

create_dxt_package() {
    echo -e "${YELLOW}📦 开始创建 DXT 格式包...${NC}"
    
    # 创建 DXT 临时目录
    local dxt_temp_dir="temp_dxt_package"
    rm -rf "$dxt_temp_dir"
    mkdir -p "$dxt_temp_dir"
    
    # 复制所有必要文件到 DXT 临时目录
    echo -e "${YELLOW}📋 复制文件到 DXT 临时目录...${NC}"
    cp -r *.py requirements.txt manifest_dxt.json "$dxt_temp_dir/"
    
    # 重命名 manifest 文件
    mv "$dxt_temp_dir/manifest_dxt.json" "$dxt_temp_dir/manifest.json"
    
    # 如果有其他必要文件，也复制过去
    if [ -f "README.md" ]; then
        cp README.md "$dxt_temp_dir/"
    fi
    
    # 进入 DXT 临时目录进行打包
    cd "$dxt_temp_dir"
    
    # 使用 mcpb 打包但输出为 .dxt 格式
    echo -e "${YELLOW}🔧 使用 mcpb 创建 DXT 格式包...${NC}"
    if mcpb pack . "../$DIST_DIR/${PROJECT_NAME}-${VERSION}.dxt"; then
        echo -e "${GREEN}✅ DXT 格式包创建成功${NC}"
        echo -e "${GREEN}📦 DXT包已生成: ${PROJECT_NAME}-${VERSION}.dxt${NC}"
    else
        echo -e "${RED}❌ DXT 格式包创建失败${NC}"
        cd ..
        return 1
    fi
    
    # 返回上级目录并清理
    cd ..
    rm -rf "$dxt_temp_dir"
}

# 验证生成的包
verify_package() {
    echo -e "${YELLOW}🔍 验证生成的包...${NC}"
    
    package_file="$DIST_DIR/${PROJECT_NAME}-${VERSION}.mcpb"
    
    if [ -f "$package_file" ]; then
        echo -e "${GREEN}✅ 包文件已生成: $package_file${NC}"
        
        # 显示文件大小
        file_size=$(ls -lh "$package_file" | awk '{print $5}')
        echo -e "${BLUE}📊 文件大小: $file_size${NC}"
        
        # 尝试验证包
        if command -v mcpb >/dev/null 2>&1; then
            if mcpb verify "$package_file"; then
                echo -e "${GREEN}✅ 包验证成功${NC}"
            else
                echo -e "${YELLOW}⚠️  包验证失败，但文件已生成${NC}"
            fi
        fi
    else
        echo -e "${RED}❌ 包文件未找到${NC}"
        exit 1
    fi
}

# 显示构建信息
show_build_info() {
    echo -e "${BLUE}📋 构建信息:${NC}"
    echo -e "  项目名称: $PROJECT_NAME"
    echo -e "  版本: $VERSION"
    echo -e "  输出文件: $DIST_DIR/${PROJECT_NAME}-${VERSION}.mcpb"
    echo -e "  构建时间: $(date)"
}

# 主函数
main() {
    echo -e "${BLUE}🎯 DXT/MCPB 构建脚本 v1.0${NC}"
    echo -e "${BLUE}================================${NC}"
    
    clean_build
    prepare_build
    copy_files
    install_dependencies
    validate_manifest
    package_mcpb
    verify_package
    show_build_info
    
    echo -e "${GREEN}🎉 构建完成！${NC}"
    echo -e "${GREEN}📦 DXT包已生成: $DIST_DIR/${PROJECT_NAME}-${VERSION}.mcpb${NC}"
}

# 处理命令行参数
case "${1:-}" in
    "clean")
        clean_build
        echo -e "${GREEN}✅ 清理完成${NC}"
        ;;
    "help"|"-h"|"--help")
        echo "用法: $0 [clean|help]"
        echo "  clean  - 仅清理构建目录"
        echo "  help   - 显示此帮助信息"
        echo "  (无参数) - 执行完整构建"
        ;;
    "")
        main
        ;;
    *)
        echo -e "${RED}❌ 未知参数: $1${NC}"
        echo "使用 '$0 help' 查看帮助"
        exit 1
        ;;
esac