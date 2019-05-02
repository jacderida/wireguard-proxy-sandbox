#!/usr/bin/env bash

proxy_dns=$(aws ec2 describe-instances \
    --filters \
    "Name=tag:Name,Values=wg_sandbox_haproxy" \
    "Name=instance-state-name,Values=running" \
    | jq '.Reservations | .[0] | .Instances | .[0] | .PublicDnsName' \
    | sed 's/\"//g')
scp -i ~/.ssh/ansible_prod -o StrictHostKeyChecking=no ~/.ssh/ansible_prod ansible@$proxy_dns:/home/ansible/.ssh/ansible_prod
ssh -i ~/.ssh/ansible_prod -o StrictHostKeyChecking=no ansible@$proxy_dns chmod 0400 /home/ansible/.ssh/ansible_prod
echo "SSH to the Bastion with: ssh -i ~/.ssh/ansible_prod ansible@$proxy_dns"
