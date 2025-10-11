FROM ccr.ccs.tencentyun.com/itqm-private/mcp-hosting:v2

WORKDIR /app
RUN mkdir -p /app

COPY nodejs/nodejs.dxt /app/nodejs.dxt
COPY scripts/run_mcp.sh /app/run_mcp.sh
RUN chmod +x /app/run_mcp.sh

# 默认启动
ENTRYPOINT [ "tail", "-f", "/dev/null" ]