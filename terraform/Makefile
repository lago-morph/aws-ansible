define DOCS
Convenience helpers for Watch and Chill IaC

inventory		build Ansible inventory

backend-init    Create S3 bucket, DynamoDB table, and output to backend.tf
                (this is completely optional)

ssh-host 		SSH to particular host
curl-host		curl to port 80 on host

apply-auto-approve			runs terraform apply --auto-approve
apply			runs terraform apply

endef


MAKEFLAGS += --jobs

SM = $(shell terraform output -raw salt_master_public_ip)

.ONESHELL:

# dummy target does nothing when make without arguments
export DOCS
show-usage: 
	@echo "$$DOCS"

inventory: INV_FILE=../ansible/inventory.ini
inventory:
	echo '[myhosts]' > $(INV_FILE)
	terraform output -raw host_public_ip >> $(INV_FILE)

apply-auto-approve:
	terraform apply --auto-approve

apply:
	terraform apply

ssh:
	ssh  -A -o "StrictHostKeyChecking no" ubuntu@$(HOST_IP)
curl:
	curl $(HOST_IP)

curl-host: HOST_IP = $(shell terraform output -raw host_public_ip)
curl-host: curl

ssh-host: HOST_IP = $(shell terraform output -raw host_public_ip)
ssh-host: ssh


create-resources:
	aws s3 mb s3://$(S3B)
	aws dynamodb create-table \
		  --table-name $(DDBNAME) \
		  --key-schema AttributeName=$(DDBKEY),KeyType=HASH \
		  --attribute-definitions AttributeName=$(DDBKEY),AttributeType=S \
		  --billing-mode PAY_PER_REQUEST \
		  --no-cli-pager

output-file:
	cat <<EOF > $(TFBACKENDFILE)
	terraform {
	  backend "s3" {
	    bucket                 = "$(S3B)"
	    region                 = "$(REGION)"
	    key                    = "backend.tfstate"
	    dynamodb_table         = "$(DDBNAME)"
	  }
	}
	EOF

backend-init: S3B := chiller-state-bucket-$(shell openssl rand -hex 10)
backend-init: DDBNAME = terraformstatelock
backend-init: DDBKEY = LockID
backend-init: REGION = $(shell aws configure get region)
backend-init: TFBACKENDFILE := backend.tf

backend-init: create-resources output-file
	terraform fmt
