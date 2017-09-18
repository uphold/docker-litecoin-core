FROM debian:wheezy-slim

MAINTAINER João Fonseca <jfonseca@uphold.com>

ENV GOSU_VERSION=1.7

RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -L https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
	&& curl -L https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc | gpg --verify - /usr/local/bin/gosu \
	&& chmod +x /usr/local/bin/gosu

ENV LITECOIN_VERSION=0.10.4.0 \
  LITECOIN_DATA=/home/litecoin/.litecoin

RUN gpg --recv-key FE3348877809386C \
  && curl -O https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux64.tar.gz \
  && curl https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux64.tar.gz.asc | gpg --verify - litecoin-${LITECOIN_VERSION}-linux64.tar.gz \
  && tar --strip=2 -xzf litecoin-${LITECOIN_VERSION}-linux64.tar.gz -C /usr/local/bin \
  && rm litecoin-${LITECOIN_VERSION}-linux64.tar.gz

EXPOSE 9332 9333 19332 19333 19444

VOLUME ["/home/litecoin/.litecoin"]

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["litecoind"]
