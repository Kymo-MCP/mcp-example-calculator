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

## Features

- Professional math tools: dedicated tools for addition, subtraction, multiplication, and division
- Detailed tool guidance: parameters, return formats, and usage examples for each tool
- Error handling: graceful handling for divide-by-zero and invalid inputs
- Transport via SSE: real-time communication using Server-Sent Events
- DXT packaging: one-click install without manual dependency setup
- MCP standard compliant: fully compatible with the MCP specification

## Installation

### Option A: Use the DXT Package (Recommended)

1. Download the DXT package
   ```bash
   # Replace with the actual download link
   wget https://your-domain.com/mcp-calculator-1.0.0.dxt
   ```

2. Install in Claude Desktop
   - Open Claude Desktop
   - Navigate to Settings → MCP Extensions
   - Click "Import DXT Package"
   - Select `mcp-calculator-1.0.0.dxt`
   - Confirm installation

3. Verify installation
   - Restart Claude Desktop
   - Ask for a math calculation in a conversation
   - The system will automatically invoke the calculator tools

### Option B: Build from Source

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd mcp-example-calculator
   ```

2. Install dependencies
   ```bash
   pip install -r requirements.txt
   ```

3. Build the DXT package
   ```bash
   ./script/build_dxt.sh
   ```

4. Install the generated DXT package
   - Follow steps 2–3 in Option A

## Usage

### In Claude Desktop

After installation, you can ask for calculations directly in conversation:

```
Please calculate 15 + 27
Calculate 100 minus 8
Compute 3.14 times 2.5
Calculate 100 divided by 8
```

### API Examples

Include `X-Session-ID` in the request headers when calling the API directly:

```bash
# Addition
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

# Subtraction
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

# Multiplication
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

# Division
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

## Technical Specs

- Protocol: MCP (Model Context Protocol)
- Transport: SSE (Server-Sent Events)
- Port: `9001`
- Python: `3.8+`
- Key dependencies: `fastmcp`, `pydantic`

## Package Structure (DXT)

```
mcp-calculator-1.0.0.dxt
├── manifest.json         # DXT manifest
├── main.py               # Service entry
├── requirements.txt      # Python dependencies
└── dependencies/         # Bundled libs
    ├── fastmcp/
    ├── pydantic/
    └── ...
```

## Troubleshooting

### Common Issues

1. Service does not start
   - Check if port `9001` is available
   - Ensure Python version is `>= 3.8`
   - Verify dependencies are installed correctly

2. Incorrect calculation results
   - Validate input types (must be numbers)
   - Confirm the correct operation is requested

3. DXT package import fails
   - Ensure your Claude Desktop version supports DXT
   - Check if the package file is intact
   - Restart Claude Desktop and try again

### Logs

```bash
# Run the service to view logs
python3 main.py

# Test SSE connection
curl -i http://localhost:9001/sse
```

## Development Info

- Version: `1.0.0`
- License: MIT
- Maintainer: Your Name
- Issues: [GitHub Issues](https://github.com/your-repo/issues)

## Changelog

### v1.0.0 (2025-01-19)
<<<<<<< HEAD
- 初始版本发布
- 支持基本四则运算
- DXT 打包支持
- SSE 协议实现
>>>>>>> a68b7a0 (feat: 初始化 MCP 计算器服务项目)
=======
- Initial release
- Supports basic arithmetic operations
- DXT packaging support
>>>>>>> 0d0b6d8 (docs: 添加中文文档并同步更新英文README)
