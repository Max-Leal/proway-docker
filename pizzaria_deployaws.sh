#!/usr/bin/env bash

yum update
yum install -y git docker cronie lsof

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# make sure every necessary service is running
for service in docker crond; do
    systemctl start $service
    systemctl enable $service
done

# variables
IP=$(curl ifconfig.me)
#LOCAL=$(readlink -f "$0")
#CRON_TASK="*/5 * * * * $LOCAL"

#Verifies if this file is already in crontab, if it's not then it adds
(crontab -l 2>/dev/null | grep -v "pizzaria_deployaws.sh"; echo "*/5 * * * * /root/proway-docker/pizzaria_deployaws.sh") | crontab -
#Uses lsof to look for any process (that is not a docker) that is using one of the doors, then kills it
for porta in 8080 5001; do
  lsof -ti:$porta | xargs -r kill -9
done

cd /root

#Verifying if the project already exists in the directory
if [ -d "proway-docker" ]; then
      #if it exists, it just pull all the possible new files
    	cd ./proway-docker
    	git reset --hard HEAD
    	git pull https://github.com/max-leal/proway-docker main
    	cd ./pizzaria-app
else
      #if it doesn't exist, it clones the project
    	git clone https://github.com/max-leal/proway-docker.git
    	cd ./proway-docker/pizzaria-app
fi

chmod +x /root/proway-docker/pizzaria_deployaws.sh

#Change the "localhost" for the actual Ip address of the machine (so it can work not only on localhost)
sed -i "s/localhost/$IP/g" ./frontend/public/index.html
#Re-builds the docker-compose to secure it doesn't forget anything
docker-compose up --build -d
