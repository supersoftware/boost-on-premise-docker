FROM alpine:latest
MAINTAINER yamazawa@supersoftware.co.jp

ENV BUILD_PACKAGES build-base git autoconf automake

RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add jq curl && \
    git clone https://github.com/jpmens/jo.git -b v1.0 jo && \
    cd jo && \
    autoreconf -i && \
    ./configure && \
    make check && \
    make install && \
    cd .. && \
    apk del $BUILD_PACKAGES && \
    rm -rf jo /var/cache/apk/* && \
    jo -v

RUN curl -L https://github.com/rancher/cli/releases/download/v0.6.1-rc2/rancher-linux-amd64-v0.6.1-rc2.tar.gz | tar zx && \
 mv rancher-*/rancher /bin/

CMD ["tail", "-F", "-n0", "/etc/hosts" ]
