default: run

tf_reqs:
	dnf install -y dnf-plugins-core
	dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
	dnf -y install terraform

requirements:
	dnf install docker -y
	mkdir -p /usr/libexec/docker/cli-plugins
	curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
	systemctl restart docker
	ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

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
