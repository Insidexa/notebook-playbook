#!/bin/bash

source /etc/profile
cd ./playbook
ansible-playbook -v uninstall.yml -i hosts/docker  --tags "uninstall"
