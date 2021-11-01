#!/bin/bash

# debug, info, error, and critical
declare -A levels=([DEBUG]=0 [INFO]=1 [ERROR]=2 [CRITICAL]=3 [UNKNOWN]=99)

# should be called as: merlin-log "log_name" "INFO" "LOG MESSAGE"
function merlin-log() {
    local log_name=$1
    local log_priority=$2
    local log_message=$3

    # If someone sets a log_priority we don't know we set to unknown and
    # print it anyway. Better than loosing it.
    if [ -z ${levels[$log_priority]} ]; then
        log_priority="UNKNOWN"
    fi

    # Grab set log level for ENV variable. Default to info
    local log_level="${LOG_LEVEL:-INFO}"
    # convert to all uppercase
    log_level="${log_level^^}"

    # ensure the log_level exists, otherwise set it to debug. This means we
    # print everything if the level was deliberately set to something we don't
    # understand
    if [ -z ${levels[$log_level]} ]; then
        log_level="DEBUG"
    fi

    # return if log level is not high enough
    if [[ ${levels[$log_priority]} < ${levels[$log_level]} ]]; then
        return 0;
    fi

    # Get date as YYYY-MM-DD HH:MM:SS,ms
    date=$(date +"%F %T,%3N")
    printf "%s %-13s %-8s %s\n" "$date" "$log_name" "$log_priority" "$log_message"
}
