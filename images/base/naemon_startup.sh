#! /bin/bash
source /usr/libexec/merlin-log.sh

function deregister_from_cluster_ok {
  [[ -n $MASTER_ADDRESS ]] && python3 -u /usr/bin/merlin_cluster_tools --deregister
  exit 0
}

function deregister_from_cluster_error {
  [[ -n $MASTER_ADDRESS ]] && python3 -u /usr/bin/merlin_cluster_tools --deregister
  exit 1
}

if [[ -n $MASTER_ADDRESS ]]; then
  python3 -u /usr/bin/merlin_cluster_tools --register
else
  merlin-log "startup" "INFO" "No master was set. Auto-registering disabled, continuing with normal startup"
fi

if [[ $? -ne 0 ]]; then
  merlin-log "startup" "CRITICAL" "Failed to register, shutting down container"
  exit 1
fi

trap deregister_from_cluster_ok SIGTERM

merlin-log "startup" "INFO" "Starting Naemon"
/usr/bin/naemon "$NAEMON_CFG"/naemon.cfg &

### Keep process alive in order to trap signals
### And check that Naemon is still alive
while :; do
  pgrep naemon > /dev/null
  if [[ $? -ne 0 ]]; then
    deregister_from_cluster_error
  fi
  sleep 1s
done
