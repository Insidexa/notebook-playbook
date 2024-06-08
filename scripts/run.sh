#!/bin/bash

NETWORK_NAME="ansible_bridge"
PROJECT_DIR=$(pwd)
USER_CNT_NAME="ansible"

# Check if the network exists
if ! podman network inspect $NETWORK_NAME &>/dev/null; then
    echo "Creating network: $NETWORK_NAME"
    podman network create $NETWORK_NAME
fi

podman build -t playbook_playground --build-arg USER=$USER_CNT_NAME -f docker/Dockerfile.dest .
podman build -t playbook_ansible --build-arg USER=$USER_CNT_NAME -f docker/Dockerfile.ansible .

podman run \
  --detach \
  --name=playground \
  --net $NETWORK_NAME \
  --network-alias playground \
  -u root \
  playbook_playground

podman run \
  --detach \
  --name=ansible \
  --userns=keep-id \
  --requires=playground \
  --net $NETWORK_NAME \
  --network-alias ansible \
  playbook_ansible \
  sleep infinity
