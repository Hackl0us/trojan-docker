FROM alpine:3.15

ARG TROJAN_VERSION='v1.16.0'

COPY trojan/cert_detect.sh /cert_detect.sh

RUN chmod +x /cert_detect.sh

RUN apk --update add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        boost-dev \
        openssl-dev \
        mariadb-connector-c-dev \
        git \
    && git clone --branch=${TROJAN_VERSION} https://github.com/trojan-gfw/trojan.git \
    && (cd trojan && cmake . && make -j $(nproc) && strip -s trojan \
    && mv trojan /usr/local/bin) \
    && rm -rf trojan \
    && apk del .build-deps \
    && apk add --no-cache --virtual .trojan-rundeps \
        libstdc++ \
        boost-system \
        boost-program_options \
        mariadb-connector-c

WORKDIR /config

CMD ["/bin/sh", "/cert_detect.sh", "trojan", "config.json"]
