FROM ruby:2.4-alpine

RUN set -ex \
 && apk add --no-cache --virtual .builddeps \
    curl \
    build-base \
    libpcap-dev \
 && gem install \
    roadworker \
 && runDeps="$( \
      scanelf --needed --nobanner --recursive /usr/local/bundle/gems/ \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u \
    )" \
 && apk add --no-cache --virtual .codenize-rundeps $runDeps \
 && curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.3/goss-linux-amd64 -o /usr/local/bin/goss \
 && chmod +x /usr/local/bin/goss \
 && apk del .builddeps

