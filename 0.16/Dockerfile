FROM debian:stretch-slim

LABEL maintainer.0="João Fonseca (@joaopaulofonseca)" \
  maintainer.1="Pedro Branco (@pedrobranco)" \
  maintainer.2="Rui Marinho (@ruimarinho)" \
  editor.0="Bruno Amaral F (@bamaralf)"

ENV GOSU_VERSION=1.10
ENV LITECOIN_VERSION=0.16.3
ENV LITECOIN_DATA=/home/litecoin/.litecoin

COPY docker-entrypoint.sh /entrypoint.sh

RUN groupadd -r litecoin && useradd -r -m -g litecoin litecoin \
  && set -ex \
  && apt-get update -y \
  && apt-get install -y curl gnupg python-setuptools python-pip procps htop \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    FE3348877809386C \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; done \
# pip install apps
  && pip install --upgrade google-cloud-logging \
  && pip install --upgrade grpcio==1.7.3 \
# gosu install
  && curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
# litecoin binaries install
  && curl -O https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && curl https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc | gpg --verify - \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz \
  # create litecoin workdir  
  && mkdir "$LITECOIN_DATA" \
  && chown -R litecoin:litecoin "$LITECOIN_DATA" \
  && ln -sfn "$LITECOIN_DATA" /home/litecoin/.litecoin \
  && chown -h litecoin:litecoin /home/litecoin/.litecoin 

VOLUME ["$LITECOIN_DATA"]

EXPOSE 9332 9333 19332 19333 19444

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9332 9333 19332 19333 19444

CMD ["litecoind"]
