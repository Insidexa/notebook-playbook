#!/bin/bash

source /etc/profile
cd ./playbook
ansible-galaxy install -r requirements.yml 
ansible-playbook -vv install.yml -i hosts/local --tags "install"
