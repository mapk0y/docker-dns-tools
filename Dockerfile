FROM circleci/ruby:2.4

USER root
RUN set -ex \
    && apt-get update \
    && apt-get install -y libpcap-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.3/goss-linux-amd64 -o /usr/local/bin/goss \
    && chmod +x /usr/local/bin/goss

RUN set -ex \
    gem install roadworker

USER circleci
