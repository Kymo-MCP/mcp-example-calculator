<<<<<<< HEAD
# MCP 示例计算器（mcp-example-calculator）

这是一个用于演示 MCP（Model Context Protocol）集成与示例的简单计算器项目模板。文档以中文编写，目标读者为想快速上手 MCP 示例项目的开发者与贡献者。

## 项目简介

该仓库提供一个轻量级的计算器示例项目，旨在演示：

- 项目结构与规范的最小模板
- 如何编写简单的算术运算模块（加、减、乘、除）
- 与 MCP 系统或其他模型驱动工具的集成示例（示例说明）

> 注意：仓库当前仅包含许可证文件（LICENSE）。README 中的安装、运行命令为通用占位示例；如果你希望我根据仓库内实际代码（例如 `package.json`、`requirements.txt`、`pom.xml`）来补全命令，我可以扫描并更新 README。

## 功能

- 支持基本算术运算：加法、减法、乘法、除法
- 可扩展的模块化结构，方便演示更多输入处理或模型推理流程
- 示例测试与使用说明（如存在）

## 快速开始（占位示例）

下面为几种常见语言/环境的占位安装与运行示例，请根据项目实际实现或告诉我需要哪个语言的示例，我会替换为准确命令：

- Node.js (npm)

```bash
# 安装依赖
npm install

# 运行
npm start

# 运行测试
npm test
```

- Python (venv + pip)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python -m src.main  # 请替换为实际入口模块
```

- Java (Maven)

```bash
mvn clean install
mvn exec:java -Dexec.mainClass="com.example.Main"  # 请替换为实际主类
```

## 项目结构（示例）

- LICENSE
- README.md
- src/    — 源代码（根据语言）
- tests/  — 测试

如果仓库已包含具体实现文件，我可以自动列出并说明真实结构。

## 贡献

欢迎贡献！常见流程：

1. Fork 仓库
2. 新建分支：git checkout -b feat/描述
3. 提交修改并推送：git commit -m "描述" && git push
4. 提交 Pull Request，描述改动与动机

在 PR 中请包含简短的测试或说明，以便快速审查。

## 许可证

本仓库使用 LICENSE 中声明的开源许可证。请参阅仓库根目录的 `LICENSE` 文件获取详细信息。

## 联系方式

如有问题，请在仓库中打开 Issue，或联系仓库所有者（Kymo-MCP）。

---

## 下一步建议

- 我可以扫描仓库以查找语言和构建文件，并把 README 中的占位命令替换为准确命令（推荐）。
- 如果你希望我生成示例实现（例如 Node.js 或 Python 版本的计算器），我可以创建源代码、测试与运行说明。
=======
# MCP Calculator Service - DXT Package

A comprehensive mathematical calculation toolkit packaged as an MCP DXT extension for easy integration with Claude Desktop and other MCP-enabled applications.

## 功能特性 (Features)

- **专业数学运算工具**: 提供独立的加法、减法、乘法、除法工具，每个工具功能明确。
- **详细工具提示**: 每个工具都包含详细的参数格式、返回值和使用示例，方便用户理解和调试。
- **错误处理**: 自动处理除零错误和无效输入，提供友好的错误提示。
- **SSE 协议**: 使用 Server-Sent Events 进行实时通信。
- **DXT 打包**: 一键安装，无需手动配置依赖。
- **标准 MCP 协议**: 完全兼容 MCP 规范。

## 安装方式

### 方式一：使用 DXT 包（推荐）

1. **下载 DXT 包**
   ```bash
   # 下载预构建的 DXT 包 (请替换为实际下载链接)
   wget https://your-domain.com/mcp-calculator-1.0.0.dxt
   ```

2. **在 Claude Desktop 中安装**
   - 打开 Claude Desktop
   - 进入设置 → MCP 扩展
   - 点击"导入 DXT 包"
   - 选择 `mcp-calculator-1.0.0.dxt` 文件
   - 确认安装

3. **验证安装**
   - 重启 Claude Desktop
   - 在对话中输入数学计算请求
   - 系统会自动调用计算器工具

### 方式二：从源码构建

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd python_test
   ```

2. **安装依赖**
   ```bash
   pip install -r requirements.txt
   ```

3. **构建 DXT 包**
   ```bash
   ./build_dxt.sh
   ```

4. **安装生成的 DXT 包**
   - 按照方式一的步骤 2-3 进行安装

## 使用方法

### 在 Claude Desktop 中使用

安装完成后，您可以直接在对话中请求数学计算：

```
请帮我计算 15 + 27
请计算 100 减去 8
帮我算一下 3.14 乘以 2.5
请计算 100 除以 8
```

### API 调用示例

如果需要直接调用 API，请确保在请求头中包含 `X-Session-ID`：

```bash
# 调用加法工具
curl -s -X POST "http://localhost:9001/messages/" \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: test_session" \
  -d '{
    "jsonrpc": "2.0",
    "method": "add",
    "params": {
      "num1": 15,
      "num2": 27
    }
  }'

# 调用减法工具
curl -s -X POST "http://localhost:9001/messages/" \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: test_session" \
  -d '{
    "jsonrpc": "2.0",
    "method": "subtract",
    "params": {
      "num1": 100,
      "num2": 8
    }
  }'

# 调用乘法工具
curl -s -X POST "http://localhost:9001/messages/" \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: test_session" \
  -d '{
    "jsonrpc": "2.0",
    "method": "multiply",
    "params": {
      "num1": 3.14,
      "num2": 2.5
    }
  }'

# 调用除法工具
curl -s -X POST "http://localhost:9001/messages/" \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: test_session" \
  -d '{
    "jsonrpc": "2.0",
    "method": "divide",
    "params": {
      "num1": 100,
      "num2": 8
    }
  }'
```

## 技术规格

- **协议**: MCP (Model Context Protocol)
- **传输**: SSE (Server-Sent Events)
- **端口**: 9001
- **Python 版本**: 3.8+
- **主要依赖**: FastMCP, Pydantic

## 文件结构

```
mcp-calculator-1.0.0.dxt
├── manifest.json          # DXT 配置文件
├── main.py               # 主服务文件
├── requirements.txt      # Python 依赖
└── dependencies/         # 打包的依赖库
    ├── fastmcp/
    ├── pydantic/
    └── ...
```

## 故障排除

### 常见问题

1. **服务无法启动**
   - 检查端口 9001 是否被占用
   - 确认 Python 版本 >= 3.8
   - 验证依赖是否正确安装

2. **计算结果错误**
   - 检查输入参数类型（必须为数字）
   - 确认运算类型参数正确

3. **DXT 包导入失败**
   - 确认 Claude Desktop 版本支持 DXT
   - 检查包文件是否完整
   - 重启 Claude Desktop 后重试

### 日志查看

```bash
# 查看服务日志
python3 main.py

# 测试连接
curl -i http://localhost:9001/sse
```

## 开发信息

- **版本**: 1.0.0
- **许可证**: MIT
- **维护者**: Your Name
- **问题反馈**: [GitHub Issues](https://github.com/your-repo/issues)

## 更新日志

### v1.0.0 (2025-01-19)
- 初始版本发布
- 支持基本四则运算
- DXT 打包支持
- SSE 协议实现
>>>>>>> a68b7a0 (feat: 初始化 MCP 计算器服务项目)
