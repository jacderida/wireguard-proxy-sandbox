#!/bin/bash

set -e

proxy_dns=$(aws ec2 describe-instances \
    --filters \
    "Name=tag:Name,Values=wg_sandbox_haproxy" \
    "Name=instance-state-name,Values=running" \
    | jq '.Reservations | .[0] | .Instances | .[0] | .PublicDnsName' \
    | sed 's/\"//g')
echo "Jenkins master is at $proxy_dns"
echo "Attempting Ansible run against macOS slave... (can be 10+ seconds before output)"
ANSIBLE_SSH_PIPELINING=true ansible-playbook -i environments/dev/hosts \
    --limit=wg_sandbox_macos_client \
    --vault-password-file=~/.ansible/vault-pass \
    --private-key=~/.ssh/id_rsa \
    -e "wg_haproxy_endpoint=$proxy_dns" \
    ansible/macos.yml
