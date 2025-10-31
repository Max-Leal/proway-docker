default: run

tf_reqs:
	dnf install -y dnf-plugins-core
	dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
	dnf -y install terraform

requirements:
	yum install docker -y
	systemctl start docker
	systemctl enable docker
	usermod -aG docker ec2-user
	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose

run:
	docker-compose -f ./pizzaria-app/docker-compose.yml up --build

stop:
	docker-compose -f ./pizzaria-app/docker-compose.yml down

deploy:
	terraform init
	terraform plan -var-file="terraform.tfvars"
	terraform apply -var-file="terraform.tfvars" -auto-approve

destroy:
	terraform destroy -var-file="terraform.tfvars" -auto-approve
