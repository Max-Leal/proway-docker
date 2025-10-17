default: run

tf_reqs:
	dnf install -y dnf-plugins-core
	dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
	dnf -y install terraform

requirements:
	mkdir -p /usr/libexec/docker/cli-plugins
	curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/libexec/docker/cli-plugins/docker-compose
	chmod +x /usr/libexec/docker/cli-plugins/docker-compose

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
