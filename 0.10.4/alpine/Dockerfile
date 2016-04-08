FROM alpine:latest

MAINTAINER João Fonseca <jfonseca@uphold.com>

RUN adduser -S litecoin

ENV GOSU_VERSION=1.7 \
  GOSU_SHASUM="34049cfc713e8b74b90d6de49690fa601dc040021980812b2f1f691534be8a50  /usr/local/bin/gosu"

RUN apk --no-cache add openssl \
  && wget -O /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 \
  && echo "${GOSU_SHASUM}" | sha256sum -c \
  && chmod +x /usr/local/bin/gosu

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/${BERKELEYDB_VERSION}

ENV LITECOIN_VERSION=0.10.4.0
ENV LITECOIN_PREFIX=/opt/litecoin-${LITECOIN_VERSION} \
  LITECOIN_SHASUM="a9adb6d2ae555afdaa2a5febb81341ac506930cf04ab95b9dc3ab99a4de0405e  v${LITECOIN_VERSION}.tar.gz" \
  LITECOIN_DATA=/home/litecoin/.litecoin
ENV PATH=${LITECOIN_PREFIX}/bin:$PATH

RUN apk --no-cache --virtual build-dependendencies add autoconf \
    automake \
    boost-dev \
    build-base \
    chrpath \
    libevent-dev \
    libtool \
    linux-headers \
    openssl-dev \
    protobuf-dev \
    zeromq-dev \
  && mkdir -p /tmp/build \
  && wget -O /tmp/build/${BERKELEYDB_VERSION}.tar.gz http://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz \
  && tar -xzf /tmp/build/${BERKELEYDB_VERSION}.tar.gz -C /tmp/build/ \
  && sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i /tmp/build/${BERKELEYDB_VERSION}/dbinc/atomic.h \
  && mkdir -p ${BERKELEYDB_PREFIX} \
  && cd /tmp/build/${BERKELEYDB_VERSION}/build_unix \
  && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX} \
  && make install \
  && wget -O /tmp/build/v${LITECOIN_VERSION}.tar.gz https://github.com/litecoin-project/litecoin/archive/v${LITECOIN_VERSION}.tar.gz \
  && cd /tmp/build \
  && echo "${LITECOIN_SHASUM}" | sha256sum -c \
  && tar -xzf v${LITECOIN_VERSION}.tar.gz \
  && cd /tmp/build/litecoin-${LITECOIN_VERSION} \
  && ./autogen.sh \
  && ./configure LDFLAGS=-L${BERKELEYDB_PREFIX}/lib/ CPPFLAGS=-I${BERKELEYDB_PREFIX}/include/ \
    --prefix=${LITECOIN_PREFIX} \
    --mandir=/usr/share/man \
    --disable-tests \
    --disable-bench \
    --disable-ccache \
    --with-gui=no \
    --with-utils \
    --with-libs \
    --with-daemon \
  && make install \
  && cd / \
  && strip ${LITECOIN_PREFIX}/bin/litecoin-cli ${LITECOIN_PREFIX}/bin/litecoind ${LITECOIN_PREFIX}/bin/litecoin-tx ${LITECOIN_PREFIX}/lib/libbitcoinconsensus.a ${LITECOIN_PREFIX}/lib/libbitcoinconsensus.so.0.0.0 \
  && rm -rf /tmp/build ${BERKELEYDB_PREFIX}/docs \
  && apk --no-cache --purge del build-dependendencies \
  && apk --no-cache add boost \
    boost-program_options \
    libevent \
    libzmq

VOLUME ["/home/litecoin/.litecoin"]

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9332 9333 19332 19333 19444

CMD ["litecoind"]
