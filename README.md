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
