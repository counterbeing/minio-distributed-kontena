#!/usr/bin/env bash
set -eo pipefail
source functions.bash
bootstrap

while true; do
  SERVER_PATHS=$(minio_server_paths)
  if [ -z SERVER_PATHS ]; then
    echo "[minio-distributed] No minio servers were found at this time!"
  else
    MINIO_COMMAND="minio server $SERVER_PATHS"
    if ! [[ $RUNNING_COMMAND == $MINIO_COMMAND ]] ; then
      restart_minio_server
      RUNNING_COMMAND=$MINIO_COMMAND
      echo "[minio-distributed] Running with command: $MINIO_COMMAND"
      $MINIO_COMMAND &
      MINIO_PID=$!
    fi
  fi
  sleep 10
done
