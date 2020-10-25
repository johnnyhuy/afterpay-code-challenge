#!/usr/bin/make

export TF_LOG=

init:
	@echo Please setup an AWS IAM admin user prior to running this command
	aws configure
	@echo Creating inline SSH key for demonstration purposes
	ssh-keygen -q -N "" -C '' -t rsa -b 4096 -f infrastructure/identity.pem
	sudo chmod 0600 infrastructure/identity.pem
	@echo Downloading Ansible community collection
	ansible-galaxy collection install -r infrastructure/requirements.yaml
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
	@echo Sync complete!

play:
	@echo WARNING! Command will not work if Terraform infrastructure has not been provisioned
	@echo Downloading Ansible community collection
	ansible-galaxy collection install -r infrastructure/requirements.yaml
	@echo Running just the Anisble playbooks
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml

destroy:
	@echo Destroying infrastructure
	cd infrastructure; terraform destroy
	@echo Ka-boom!

re-create:
	@echo Re-creating infrastructure
	@echo Tearing down Terraform
	cd infrastructure; terraform destroy -auto-approve
	@echo Re-applying Terraform
	cd infrastructure; terraform apply -auto-approve
	@echo Re-applying Ansible playbook
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml

version:
ifndef GH_TOKEN
	$(error GH_TOKEN environment variable - GitHub token is required for GitHub releases)
endif
ifndef GH_EMAIL
	$(error GH_EMAIL environment variable - GitHub email is required for GitHub releases)
endif
ifndef GH_USERNAME
	$(error GH_USERNAME environment variable - GitHub username is required for GitHub releases)
endif
	@echo Node.js v14+ required
	@echo Semantic releasing Git changes
	npx semantic-release --no-ci
