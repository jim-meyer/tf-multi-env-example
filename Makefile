check:
	terraform validate

#
# These targets assume AWS credentials are set for the proper deployment account: sandbox, prod
#
deploy_sandbox:
  # This assumes AWS credentials are set for the proper deployment account: sandbox, prod
	aws s3 mb "s3://tf-multi-env-example-terraform-state-sandbox" || true
	terraform init -reconfigure -backend-config=sandbox/backend.tf
	terraform apply -var-file sandbox/variables.tfvars -auto-approve

undeploy_sandbox:
	terraform init -reconfigure -backend-config=sandbox/backend.tf
	terraform destroy -var-file sandbox/variables.tfvars -auto-approve

deploy_prod:
	aws s3 mb "s3://tf-multi-env-example-terraform-state-prod" || true
	terraform init -reconfigure -backend-config=prod/backend.tf
	terraform apply -var-file prod/variables.tfvars -auto-approve

undeploy_prod:
	terraform init -reconfigure -backend-config=prod/backend.tf
	terraform destroy -var-file prod/variables.tfvars -auto-approve
