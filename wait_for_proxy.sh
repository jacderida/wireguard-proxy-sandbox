#!/usr/bin/env bash

proxy_dns=$(aws ec2 describe-instances \
    --filters \
    "Name=tag:Name,Values=wg_sandbox_haproxy" \
    "Name=instance-state-name,Values=running" \
    | jq '.Reservations | .[0] | .Instances | .[0] | .PublicDnsName' \
    | sed 's/\"//g')

ssh -i ~/.ssh/ansible_prod -o StrictHostKeyChecking=no ansible@"$proxy_dns" ls
rc=$?
while [[ $rc != 0 ]]
do
    ssh -i ~/.ssh/ansible_prod -o StrictHostKeyChecking=no ansible@"$proxy_dns" ls
    rc=$?
    echo "SSH not yet available on $proxy_dns, sleeping for 5 seconds before retry..."
done

echo "SSH available on $proxy_dns, now running apt-get update..."
ssh -i ~/.ssh/ansible_prod -o StrictHostKeyChecking=no ansible@"$proxy_dns" sudo apt-get update -y
