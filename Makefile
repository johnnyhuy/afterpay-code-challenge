#!/usr/bin/make

export TF_LOG=

init:
	@echo Please setup an AWS IAM admin user prior to running this command
	aws configure
	@echo Creating inline SSH key (for demonstration purposes)
	ssh-keygen -q -N "" -C '' -t rsa -b 4096 -f infrastructure/identity.pem
	sudo chmod 0600 infrastructure/identity.pem
	@echo VM SSH key is located at infrastructure/identity
	@echo Please run "make deploy" to deploy infrastructure or "make sync" to deploy infrastructure and configure instances

deploy:
	@echo WARNING! Make sure we have configured AWS CLI 'aws configure'
	cd infrastructure; terraform init
	cd infrastructure; terraform apply

sync:
	@echo This task will automatically apply Terraform and Ansible changes
	cd infrastructure; terraform init
	cd infrastructure; terraform apply -auto-approve
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml

play:
	@echo WARNING! Command will not work if Terraform infrastructure has not been provisioned
	@echo Running just the Anisble playbooks
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml

destroy:
	cd infrastructure; terraform destroy

re-create:
	cd infrastructure; terraform destroy -auto-approve
	cd infrastructure; terraform apply -auto-approve
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml
