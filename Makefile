#!/usr/bin/make

export TF_LOG=

init:
	aws configure
	ssh-keygen -q -N "" -C '' -t rsa -b 4096 -f infrastructure/vm-stack/identity.pem
	sudo chmod 0600 infrastructure/vm-stack/identity.pem

deploy:
	@echo WARNING! Make sure we have configured AWS CLI 'aws configure'
	cd infrastructure/vm-stack; terraform init
	cd infrastructure/vm-stack; terraform apply

sync:
	@echo This task will automatically apply Terraform and Ansible changes
	cd infrastructure/vm-stack; terraform init
	cd infrastructure/vm-stack; terraform apply -auto-approve
	cd infrastructure/vm-stack; ansible-playbook -i terraform-inventory.py playbook.yaml

play:
	@echo WARNING! Command will not work if Terraform infrastructure has not been provisioned
	@echo Running just the Anisble playbooks
	cd infrastructure/vm-stack; ansible-playbook -i terraform-inventory.py playbook.yaml

destroy:
	cd infrastructure/vm-stack; terraform destroy

re-create:
	cd infrastructure/vm-stack; terraform destroy -auto-approve
	cd infrastructure/vm-stack; terraform apply -auto-approve
	cd infrastructure/vm-stack; ansible-playbook -i terraform-inventory.py playbook.yaml
