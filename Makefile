dev-apply:
	git pull
	rm -f .terraform/terraform.tfstate
	terrafrom init -backend-config=environments/dev/state.tfvars
	terraform apply auto-approve -var-file=environments/dev/main.tfvars

dev-destroy:
	git pull
	rm -f .terraform/terraform.tfstate
	terrafrom init -backend-config=environments/dev/state.tfvars
	terraform destroy auto-approve -var-file=environments/dev/main.tfvars


prd-apply:
	git pull
	rm -f .terraform/terraform.tfstate
	terrafrom init -backend-config=environments/prd/state.tfvars
	terraform apply auto-approve -var-file=environments/prd/main.tfvars

prd-destroy:
	git pull
	rm -f .terraform/terraform.tfstate
	terrafrom init -backend-config=environments/prd/state.tfvars
	terraform destroy auto-approve -var-file=environments/prd/main.tfvars

