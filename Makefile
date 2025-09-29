# Makefile for MCP Calculator Service DXT/MCPB Package
# 用于管理 DXT/MCPB 扩展包的构建流程

# 项目目录
PROJECT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
# 项目配置
PROJECT_NAME := mcp-calculator-service
VERSION := 1.0.0
BUILD_DIR := $(PROJECT_DIR)/build
DIST_DIR := $(PROJECT_DIR)/dist
PACKAGE_FILE := $(DIST_DIR)/$(PROJECT_NAME)-$(VERSION).mcpb



# Python配置
PYTHON := python3
PIP := pip3
VENV_DIR := venv

# 颜色定义
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

.PHONY: create-dirs
create-dirs:
	@echo "$(BLUE)📁 创建目录...$(NC)"
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(DIST_DIR)

# zip 压缩 python 项目
.PHONY: zip-python
zip-python:
	@echo "$(YELLOW)📦 压缩 Python 项目...$(NC)"
	@zip -j -r $(BUILD_DIR)/$(PROJECT_NAME)-$(VERSION).zip $(PROJECT_DIR)/main.py $(PROJECT_DIR)/README.md $(PROJECT_DIR)/requirements.txt
	@echo "$(GREEN)✅ Python 项目已压缩: $(BUILD_DIR)/$(PROJECT_NAME)-$(VERSION).zip$(NC)"