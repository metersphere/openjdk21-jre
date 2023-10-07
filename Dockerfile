FROM alpine:3.18.4

USER root

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN mkdir -p /deployments

COPY run-java.sh /deployments/

ENV JAVA_APP_DIR=/deployments \
    JAVA_OPTIONS="-Dfile.encoding=utf-8" \
    LOG4J_FORMAT_MSG_NO_LOOKUPS=true \
    JAVA_MAJOR_VERSION=21 \
    JAVA_MAX_HEAP_RATIO=40

RUN apk add --update --no-cache tzdata curl fontconfig ttf-dejavu openjdk21-jre nss bash \
 && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata \
 && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security \
 && curl -L --connect-timeout 60 -m 1800 https://fit2cloud-support.oss-cn-beijing.aliyuncs.com/xpack-license/get-validator-linux | sh \
 && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* \
 && chmod 755 /deployments/run-java.sh \
 && adduser -D appuser && addgroup appuser root \
 && chmod 744 /bin/busybox && chmod 744 `which curl` `which apk` \
 && echo "set disable-completion on" >> /etc/inputrc

CMD [ "/deployments/run-java.sh" ]
