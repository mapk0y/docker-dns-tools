FROM ruby:2.7-alpine

ENV GOSS_VERSION 0.3.15
ENV ROADWORKER_VERSION 0.5.14

RUN set -ex \
 && apk add --no-cache \
    git \
    openssh \
 && apk add --no-cache --virtual .builddeps \
    curl \
    build-base \
    libpcap-dev \
 && gem install \
    roadworker -v ${ROADWORKER_VERSION} \
 && runDeps="$( \
      scanelf --needed --nobanner --recursive /usr/local/bundle/gems/ \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u \
    )" \
 && apk add --no-cache --virtual .codenize-rundeps $runDeps \
 && curl -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64 -o /usr/local/bin/goss \
 && chmod +x /usr/local/bin/goss \
 && apk del .builddeps
