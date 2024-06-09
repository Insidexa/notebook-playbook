#!/bin/bash

NETWORK_NAME="ansible_bridge"
PROJECT_DIR=$(pwd)
USER_CNT_NAME="ansible"
HOME_DIR="/home/$USER_CNT_NAME"

# Check if the network exists
if ! podman network inspect $NETWORK_NAME &>/dev/null; then
    echo "Creating network: $NETWORK_NAME"
    podman network create $NETWORK_NAME
fi

podman build -t playbook_playground --build-arg USER=$USER_CNT_NAME -f docker/Dockerfile.dest .
podman build -t playbook_ansible --build-arg USER=$USER_CNT_NAME -f docker/Dockerfile.ansible .

ssh-keygen -t rsa -b 4096 -C "ansible" -f ./docker/keys/id_rsa -N ""  <<< 'y'

podman run \
  --detach \
  --name=playground \
  -v ./docker/keys/id_rsa.pub:$HOME_DIR/.ssh/authorized_keys:Z,ro \
  --net $NETWORK_NAME \
  --network-alias playground \
  -u root \
  playbook_playground

podman run \
  --detach \
  --name=ansible \
  --userns=keep-id \
  --requires=playground \
  -v ./playbook/:$HOME_DIR/playbook/:Z,ro \
  -v ./scripts/:$HOME_DIR/scripts/:Z,ro \
  -v ./docker/keys/id_rsa:$HOME_DIR/.ssh/id_rsa:Z,ro \
  --net $NETWORK_NAME \
  --network-alias ansible \
  playbook_ansible \
  sleep infinity
