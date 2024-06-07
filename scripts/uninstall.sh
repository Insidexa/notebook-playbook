#!/bin/bash

source /etc/profile
ansible-playbook -vvv uninstall.yml -i hosts/docker --tags "uninstall"
