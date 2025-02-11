#!/usr/bin/env bash
set -e

if [ $# -eq 0 ]; then
    echo -e "Usage:\n  $0 <instance_id> <bootstrap_ip>\nWhere <instance_id> should be unique for each call, for example:\n  $0 first \nWhere <bootstrap_ip> provide remote bootstrap node ip for remote connection, alternatively assumed to be local. for example: \n  $0 farm 0.0.0.0"
    exit 1
fi

BOOTSTRAP_CLIENT_IP=${2:-$(docker inspect -f "{{.NetworkSettings.Networks.subspace.IPAddress}}" subspace-node)}

cd $(dirname ${BASH_SOURCE[0]})

export BOOTSTRAP_CLIENT_IP
export INSTANCE_ID="$1"
export COMPOSE_PROJECT_NAME="subspace-$INSTANCE_ID"
stop() {
  docker-compose down -t 10 || /bin/true
}

trap 'stop' SIGINT

docker-compose pull

docker-compose up
