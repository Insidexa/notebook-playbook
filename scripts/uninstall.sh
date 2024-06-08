#!/bin/bash

source /etc/profile
cd ./playbook
ansible-playbook -vvv uninstall.yml -i hosts/docker --tags "uninstall"
