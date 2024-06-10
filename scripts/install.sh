#!/bin/bash

source /etc/profile
cd ./playbook
ansible-galaxy install -r requirements.yml
ansible-playbook -v install.yml -i hosts/docker --tags "install"
