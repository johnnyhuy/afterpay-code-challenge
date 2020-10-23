#!/usr/bin/make

export TF_LOG=ERROR

deploy:
	@echo WARNING! Make sure we have configured AWS CLI 'aws configure'
	cd infrastructure/vm-stack; terraform init
	cd infrastructure/vm-stack; terraform apply

auto-deploy:
	cd infrastructure/vm-stack; terraform init
	cd infrastructure/vm-stack; terraform apply -auto-approve

destroy:
	@echo Otherwise deployment will hang for a long time and fail
	cd infrastructure/vm-stack; terraform destroy
