#!/usr/bin/env bash

yum update -y
yum install -y git docker cronie lsof

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

for service in docker crond; do
    systemctl start $service
    systemctl enable $service
done

cd /root

if [ ! -d "proway-docker" ]; then
    git clone https://github.com/BryanPacker/proway-docker.git
    cd proway-docker
else
    cd proway-docker
    git fetch origin
    git reset --hard origin/main 2>/dev/null || git reset --hard origin/master
fi

chmod +x /root/proway-docker/projeto_pizza.sh

for porta in 80 5001; do
    lsof -ti:$porta | xargs -r kill -9
done

# Define variables for server IP and frontend directory
SERVER_IP=$(curl ifconfig.me)
FRONTEND_DIR="pizzaria-app/frontend"

 Update Dockerfile with the correct backend URL
if [ -f "$FRONTEND_DIR/Dockerfile" ]; then
    sed -i "s|REACT_APP_BACKEND_URL=http://.*:5001|REACT_APP_BACKEND_URL=http://$SERVER_IP:5001|g" "$FRONTEND_DIR/Dockerfile"
fi

#Update index.html with the correct backend URL
if [ -f "$FRONTEND_DIR/public/index.html" ]; then
    sed -i "s|http://.*:5001|http://$SERVER_IP:5001|g" "$FRONTEND_DIR/public/index.html"
fi

cd /root/proway-docker/
docker-compose -f pizza2.yml up -d --build

(crontab -l 2>/dev/null | grep -v "projeto_pizza.sh"; echo "*/5 * * * * /root/proway-docker/projeto_pizza.sh") | crontab -

touch /root/proway-docker/cron.log
echo "$(date '+%c'): Cron job executed successfully!" > /root/proway-docker/cron.log

echo " --------------------------------------------- "
echo " Application deployed successfully. "
echo " --------------------------------------------- "
