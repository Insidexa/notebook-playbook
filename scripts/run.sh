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
  -p 8000:80 \
  -u root \
  playbook_playground

podman run \
  --detach \
  --name=ansible \
  --userns=keep-id \
  --requires=playground \
  -v $PROJECT_DIR:/home/ansible/playbook:Z \
  -v $PROJECT_DIR/docker/config/ansible.cfg:/etc/ansible/ansible.cfg:Z \
  -v $PROJECT_DIR/docker/config/ssh_config:/home/$USER_CNT_NAME/.ssh/config:Z,ro \
  -v $PROJECT_DIR/docker/keys/ansible:/home/$USER_CNT_NAME/.ssh/id_rsa:Z,ro \
  --net $NETWORK_NAME \
  --network-alias ansible \
  playbook_ansible \
  sleep infinity
