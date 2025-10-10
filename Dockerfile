FROM python:3.10

WORKDIR /app

# 安装 Python 运行依赖库（不是 python3.10）
RUN apt-get update && apt-get install -y --no-install-recommends \
    libexpat1 \
    libffi8 \
    libssl3 \
    libbz2-1.0 \
    liblzma5 \
    && rm -rf /var/lib/apt/lists/*

COPY launcher.py /app/launcher.py
COPY SimpleMCP.dxt /app/SimpleMCP.dxt

# 默认启动
CMD ["python3", "launcher.py"]
