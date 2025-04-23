FROM alpine

RUN apk add --no-cache curl tar && \
    curl -L https://github.com/fatedier/frp/releases/download/v0.53.4/frp_0.53.4_linux_amd64.tar.gz | \
    tar xz && mv frp_0.53.4_linux_amd64 /frp

WORKDIR /frp
CMD ["./frps", "-c", "./frps.ini"]
