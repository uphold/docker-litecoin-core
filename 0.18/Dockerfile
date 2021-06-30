FROM debian:stable-slim

LABEL maintainer.0="João Fonseca (@joaopaulofonseca)" \
  maintainer.1="Pedro Branco (@pedrobranco)" \
  maintainer.2="Rui Marinho (@ruimarinho)"

# Fix for arm64 builds
# @see https://github.com/moby/buildkit/issues/1929
RUN echo This is to fix linux/arm build \
 && for U in dpkg-split dpkg-deb tar rm; do \
        ln -fs `which $U` /usr/sbin/; \
        ln -fs `which $U` /usr/local/sbin/; \
    done
# end

RUN useradd -r litecoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex \
  && for key in \
    B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    FE3348877809386C \
  ; do \
    gpg --no-tty --allow-non-selfsigned-uid --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --no-tty --keyserver keys.openpgp.org --recv-keys "$key" || \
    gpg --no-tty --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
  done

# Fix for arm64 builds
# @see https://github.com/moby/buildkit/issues/1929
RUN for U in dpkg-split dpkg-deb tar rm; do \
        rm /usr/sbin/$U /usr/local/sbin/$U; \
    done
# end

ENV GOSU_VERSION=1.10

RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

ENV LITECOIN_VERSION=0.18.1
ENV LITECOIN_DATA=/home/litecoin/.litecoin

RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && gpg --verify litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && grep $(sha256sum litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LITECOIN_VERSION}-linux-signatures.asc \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/litecoin/.litecoin"]

EXPOSE 9332 9333 19332 19333 19444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["litecoind"]
