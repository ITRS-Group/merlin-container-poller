#!/bin/bash
source /usr/libexec/merlin-log.sh
set -e

# correct permissions on .ssh
chmod 700 ~/.ssh/

# include nss_wrapper code
source /usr/local/bin/nss_wrapper.sh

if [ ! -f "$NAEMON_CFG"/naemon.cfg ]; then
  merlin-log "init" "INFO" "No Naemon config found, copying default config"
  cp -r /usr/local/etc/naemon/default_config/* "$NAEMON_CFG"
  mkdir "$NAEMON_CFG"/oconf
fi

# Wait for merlin container to come online, as Naemon requires the socket to be
# available at startup
max_wait_s=60
wait_step_s=5
current_wait=0
while [ ! -e "$MERLIN_SOCK" ]
do
  merlin-log "init" "INFO" "Waiting for merlin socket..."
  sleep $wait_step_s
  current_wait=$(( $current_wait + $wait_step_s ))
  if [ $current_wait -ge $max_wait_s ]; then
    merlin-log "init" "CRITICAL" "Merlin socket did not come up after $current_wait seconds. Exiting"
    exit 1
  fi
done

exec /usr/local/bin/tini -- $@
