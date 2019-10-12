infrastructure:
	# Get the modules, create the infrastructure.
	terraform init && terraform get && terraform apply -auto-approve

dtmanaged:
	./scripts/dtm-setup.sh
	# build the Dynatrace Managed Cluster 
	ssh-add ~/.ssh/id_rsa
	ssh-keyscan -t rsa -H $$(terraform output activegate-public_ip) >> ~/.ssh/known_hosts
	ssh -A ec2-user@$$(terraform output activegate-public_ip) "ssh-keyscan -t rsa -H master.dtmanaged.local >> ~/.ssh/known_hosts"        
	- cat ./scripts/dtm-install.sh | ssh -A ec2-user@$$(terraform output activegate-public_ip) ssh master.dtmanaged.local
	echo "Complete!"

# Destroy the infrastructure.
destroy:
	- cat ./scripts/dtm-unregister.sh | ssh -A ec2-user@$$(terraform output activegate-public_ip) ssh master.dtmanaged.local
	terraform init && terraform destroy -auto-approve

# Open the console.
browse-dtmanaged:
	open $$(terraform output dtmanaged-url)

# SSH onto the DT Managed master.
ssh-activegate:
	ssh -t -A ec2-user@$$(terraform output activegate-public_ip)
ssh-dtmanaged:
	ssh -t -A ec2-user@$$(terraform output activegate-public_ip) ssh master.dtmanaged.local

# Lint the terraform files. Don't forget to provide the 'region' var, as it is
# not provided by default. Error on issues, suitable for CI.
lint:
	terraform get
	TF_VAR_region="us-east-1" tflint --error-with-issues

# Run the tests.
test:
	echo "Simulating tests..."

.PHONY: sample
