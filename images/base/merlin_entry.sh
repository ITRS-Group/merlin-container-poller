#!/bin/bash
source /usr/libexec/merlin-log.sh
set -e

# include nss_wrapper code
source /usr/local/bin/nss_wrapper.sh

if [ ! -f "$MERLIN_CFG"/merlin.conf ]; then
  merlin-log "init" "INFO" "No Merlin config found, copying default config"
  cp /usr/local/etc/merlin/default_config/merlin.conf "$MERLIN_CFG"/merlin.conf
fi

exec "$@"
