#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for litecoind"

  set -- litecoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "litecoind" ]; then
  mkdir -p "$LITECOIN_DATA"
  chmod 700 "$LITECOIN_DATA"
  chown -R litecoin "$LITECOIN_DATA" || echo "Could not chown $LITECOIN_DATA (may not have permission)"

  echo "$0: setting data directory to $LITECOIN_DATA"

  set -- "$@" -datadir="$LITECOIN_DATA"
fi

if [ "$1" = "litecoind" ] || [ "$1" = "litecoin-cli" ] || [ "$1" = "litecoin-tx" ]; then
  echo
  if [ "$(id -u)" = '0' ]; then
    exec gosu litecoin "$@"
  else
    exec "$@"
  fi
fi

echo
exec "$@"
