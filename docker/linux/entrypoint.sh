#!/usr/bin/dumb-init /bin/sh

set -e

# Grab the DNS suffix, and remove the svc prefix
CLUSTER_NAME=$(cat /etc/resolv.conf | grep -o '^[^#]*' | cut -d " " -f 3 | xargs | sed -e 's/svc.//')

echo $CLUSTER_NAME

# Set cluster name as env var
export CLUSTER_NAME="$CLUSTER_NAME"

env

echo $@
echo "fluentd $@"

exec fluentd "$@"
