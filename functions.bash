#!/usr/bin/env bash



minio_server_paths() {
  echo $(
    curl -Ls "http://$ETCD_NODE/v2/keys/$UPSTREAM_KEY" |
    jq '.node.nodes[].value' |
    tr -d '"' |
    sed 's/:9000//g' |
    sort |
    awk '{print "http://" $0 "/export"}'
  )
}

# This regex is here to find out where we can look for all of the other minio
# nodes through etcd. It's ugly, but it means I don't have to keep tweaking
# names when my config changes.
upstreams_key() {
  echo $(
    curl -sL "http://$ETCD_NODE/v2/keys/kontena/haproxy/$KONTENA_STACK_NAME?recursive=true" |
    sed -n "s/.*\"\(\/kontena\/haproxy\/.*$KONTENA_SERVICE_NAME\/upstreams\)\/.*\".*/\1/p"
  )
}

restart_minio_server() {
  re='^[0-9]+$'
  if [[ $MINIO_PID =~ $re ]] ; then
    echo "[minio-distributed] restarting minio by killing $MINIO_PID because config changed"
    kill $MINIO_PID > /dev/null 2>&1
  fi
}

set_etcd_node() {
  if [ -z "$ETCD_NODE" ]; then
    IP=$(/sbin/ip route | awk '/default/ { print $3 }')
    ETCD_NODE=$IP:2379
  fi
  echo "[minio-distributed] Using etcd: $ETCD_NODE"
}

bootstrap() {
  set_etcd_node
  UPSTREAM_KEY=$(upstreams_key)
}
