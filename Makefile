default: deploy

run:
	docker-compose -f /proway-docker/pizzaria-app/docker-compose.yml up --build

stop:
	docker-compose -f /proway-docker/pizzaria-app/docker-compose.yml down

deploy:
	terraform init
	terraform plan -var-file="terraform.tfvars"
	terraform apply -var-file="terraform.tfvars" -auto-approve

destroy:
	terraform destroy -var-file="terraform.tfvars" -auto-approve
