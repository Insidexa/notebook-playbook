#!/bin/bash

source /etc/profile
ansible-galaxy install -r requirements.yml 
ansible-playbook -vv install.yml -i hosts/local --tags "install"
