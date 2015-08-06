#!/bin/bash
set -e

# fix permissions on the log dir
mkdir -p ${SQUID_LOG_DIR}
chmod -R 755 ${SQUID_LOG_DIR}
chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}

# fix permissions on the cache dir
mkdir -p ${SQUID_CACHE_DIR}
chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}

/usr/lib/squid3/ssl_crtd -c -s /var/lib/ssl_db/
chown -R ${SQUID_USER}:${SQUID_USER} /var/lib/ssl_db

# deprecated: backward compatibility
if [[ -f /etc/squid3/squid.user.conf ]]; then
  rm -rf /etc/squid3/squid.conf
  ln -sf /etc/squid3/squid.user.conf /etc/squid3/squid.conf
fi

# allow arguments to be passed to squid3
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid3 || ${1} == $(which squid3) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid3) -N -f /etc/squid3/squid.conf -z
  fi
  echo "Starting squid3..."
  exec $(which squid3) -f /etc/squid3/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
