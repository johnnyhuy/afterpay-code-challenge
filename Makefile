#!/usr/bin/make

export TF_LOG=
export RED=\033[0;31m
export GREEN=\033[0;32m
export CYAN=\033[0;36m
export YELLOW=\033[1;33m
export RESET=\033[0m

ifeq (, $(shell which python))
$(error "No 'python' found in PATH, please install the tool before continuing")
endif

ifeq (, $(shell which ansible))
$(error "No 'ansible' found in PATH, please install the tool before continuing")
endif

ifeq (, $(shell which terraform))
$(error "No 'terraform' found in PATH, please install the tool before continuing")
endif

ifeq (, $(shell which ssh-keygen))
$(error "No 'ssh-keygen' found in PATH, please install the tool before continuing")
endif

init:
	@printf '$(YELLOW)Please setup an AWS IAM admin user prior to running this command$(RESET)\n'
	aws configure
	@printf '$(CYAN)Creating inline SSH key for demonstration purposes$(RESET)\n'
	ssh-keygen -q -N "" -C '' -t rsa -b 4096 -f infrastructure/identity.pem
	sudo chmod 0600 infrastructure/identity.pem
	@printf '$(CYAN)Downloading Ansible community collection$(RESET)\n'
	ansible-galaxy collection install -r infrastructure/requirements.yaml
	@printf '$(YELLOW)VM SSH key is located at infrastructure/identity.pem$(RESET)\n'
	@printf '$(CYAN)Please run "make deploy" to deploy infrastructure or "make sync" to deploy infrastructure and configure instances$(RESET)\n'

deploy:
	@printf '$(YELLOW)WARNING! Make sure we have configured AWS CLI "aws configure"$(RESET)\n'
	cd infrastructure; terraform init
	cd infrastructure; terraform apply
	@printf '\n$(GREEN)The following EC2 instances are now available$(RESET)\n\n'
	@printf '    $(YELLOW)ssh ubuntu@$(shell cd infrastructure; terraform output host_a_dns) -i infrastructure/identity.pem$(RESET)\n'
	@printf '    $(YELLOW)ssh ubuntu@$(shell cd infrastructure; terraform output host_b_dns) -i infrastructure/identity.pem$(RESET)\n'
	@printf '    $(YELLOW)ssh ubuntu@$(shell cd infrastructure; terraform output host_c_dns) -i infrastructure/identity.pem$(RESET)\n\n'
	@printf '$(GREEN)Terraform deployment complete!$(RESET)\n'

sync:
	@printf '$(YELLOW)This task will automatically apply Terraform and Ansible changes$(RESET)\n'
	cd infrastructure; terraform init
	cd infrastructure; terraform apply -auto-approve
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml
	@printf '\n$(GREEN)The following EC2 instances are now available$(RESET)\n\n'
	@printf '    $(YELLOW)ssh ubuntu@$(shell cd infrastructure; terraform output host_a_dns) -i infrastructure/identity.pem$(RESET)\n'
	@printf '    $(YELLOW)ssh ubuntu@$(shell cd infrastructure; terraform output host_b_dns) -i infrastructure/identity.pem$(RESET)\n'
	@printf '    $(YELLOW)ssh ubuntu@$(shell cd infrastructure; terraform output host_c_dns) -i infrastructure/identity.pem$(RESET)\n\n'
	@printf '$(GREEN)Terraform deployment complete!$(RESET)\n'
	@printf '\n$(GREEN)The website is now available$(RESET)\n\n'
	@printf '    $(YELLOW)curl http://$(shell cd infrastructure; terraform output load_balancer_dns)$(RESET)\n\n'
	@printf '$(GREEN)Ansible deployment complete!$(RESET)\n'
	@printf '$(GREEN)Sync complete!$(RESET)\n'

play:
	@printf '$(YELLOW)WARNING! Command will not work if Terraform infrastructure has not been provisioned$(RESET)\n'
	@printf '$(CYAN)Downloading Ansible community collection$(RESET)\n'
	ansible-galaxy collection install -r infrastructure/requirements.yaml
	@printf '$(CYAN)Running just the Anisble playbooks$(RESET)\n'
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml
	@printf '$(GREEN)The website is now available$(RESET)\n\n'
	@printf '    $(YELLOW)curl http://$(shell cd infrastructure; terraform output load_balancer_dns)$(RESET)\n\n'
	@printf '$(GREEN)Ansible deployment complete!$(RESET)\n'

destroy:
	@printf 'Destroying infrastructure$(RESET)\n'
	cd infrastructure; terraform destroy
	@printf 'Ka-boom!$(RESET)\n'

re-create:
	@printf '$(CYAN)Re-creating infrastructure$(RESET)\n'
	@printf '$(CYAN)Tearing down Terraform$(RESET)\n'
	cd infrastructure; terraform destroy -auto-approve
	@printf '$(CYAN)Re-applying Terraform$(RESET)\n'
	cd infrastructure; terraform apply -auto-approve
	@printf '$(CYAN)Re-applying Ansible playbook$(RESET)\n'
	cd infrastructure; ansible-playbook -i terraform-inventory.py playbook.yaml

version:
	ifeq (, $(shell which node))
	$(error "No 'node' found in PATH, please install the tool before continuing")
	endif
	ifndef GH_TOKEN
	$(error GH_TOKEN environment variable - GitHub token is required for GitHub releases)
	endif
	ifndef GH_EMAIL
	$(error GH_EMAIL environment variable - GitHub email is required for GitHub releases)
	endif
	ifndef GH_USERNAME
	$(error GH_USERNAME environment variable - GitHub username is required for GitHub releases)
	endif
	@printf '$(CYAN)Node.js v14+ required$(RESET)\n'
	@printf '$(CYAN)Semantic releasing Git changes$(RESET)\n'
	npx semantic-release --no-ci
	