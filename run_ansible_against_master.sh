#!/bin/bash

set -e

proxy_dns=$(aws ec2 describe-instances \
    --filters \
    "Name=tag:Name,Values=wg_sandbox_jenkins_master" \
    "Name=instance-state-name,Values=running" \
    | jq '.Reservations | .[0] | .Instances | .[0] | .PublicDnsName' \
    | sed 's/\"//g')
echo "Remote endpoint is at $proxy_dns"
EC2_INI_PATH=environments/dev/ec2-bastion.ini ansible-playbook -i environments/dev \
    --vault-password-file=~/.ansible/vault-pass \
    --private-key=~/.ssh/ansible_prod \
    --limit=wg_sandbox_jenkins_master \
    -e "wg_haproxy_endpoint=$proxy_dns" \
    -u ansible ansible/master.yml
