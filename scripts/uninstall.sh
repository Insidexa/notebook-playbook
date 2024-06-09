#!/bin/bash

source /etc/profile
cd ./playbook
ansible-playbook -vv uninstall.yml -i hosts/docker
