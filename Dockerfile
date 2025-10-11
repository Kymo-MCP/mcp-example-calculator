FROM ccr.ccs.tencentyun.com/itqm-private/mcp-hosting:v2

WORKDIR /app
RUN mkdir -p /app &&\
    apk add --no-cache bash &&\
    apk add --no-cache jq

COPY nodejs/nodejs.dxt /app/nodejs.dxt
COPY scripts/run_mcp.sh /app/run_mcp.sh
RUN chmod +x /app/run_mcp.sh

# 默认启动
ENTRYPOINT [ "/app/run_mcp.sh" , "/app/nodejs.dxt" ]