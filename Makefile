environment:
ifndef AWS_ACCESS_KEY_ID
	@echo "Your AWS access key ID must be set."
	@exit 1
endif
ifndef AWS_SECRET_ACCESS_KEY
	@echo "Your AWS secret access key must be set."
	@exit 1
endif
	cd terraform && terraform init && terraform apply -auto-approve
	rm -rf ~/.ansible/tmp
	./wait_for_proxy.sh
	EC2_INI_PATH=environments/dev/ec2.ini ansible-playbook -i environments/dev \
		--vault-password-file=~/.ansible/vault-pass \
		--private-key=~/.ssh/ansible_prod \
		--limit=wg_sandbox_haproxy \
		-e "aws_access_key_id=${AWS_ACCESS_KEY_ID}" \
		-e "aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" \
		-e "ansible_vault_password=$$(cat ~/.ansible/vault-pass)" \
		-u ansible ansible/proxy.yml
	./prepare_proxy.sh

provision-master:
	EC2_INI_PATH=environments/dev/ec2-bastion.ini ansible-playbook -i environments/dev \
		--vault-password-file=~/.ansible/vault-pass \
		--private-key=~/.ssh/ansible_prod \
		--limit=wg_sandbox_haproxy \
		-u ansible ansible/master.yml
