#!/bin/bash

source /etc/profile
cd ./playbook
ansible-galaxy install -r requirements.yml 
ssh-keyscan -H $(sed -n 2p hosts/docker) >> ~/.ssh/known_hosts
ansible-playbook -vv install.yml -i hosts/docker --tags "install"
