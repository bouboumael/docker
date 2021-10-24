#!/bin/sh

sudo true

read -p "Voulez-vous intaller docker et docker-compose (N/o)" INIT

if [ "$INIT" = "o" ]
then
    echo -e "\n"
    echo "+--------------------------+"
    echo "|  Installation de Docker  |"
    echo "+--------------------------+"
    echo -e "\n"

    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo  apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io

    echo -e "\n"
    echo "+----------------------------------+"
    echo "|  Installation de Docker-Compose  |"
    echo "+----------------------------------+"
    echo -e "\n"

    sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    if [ !$(getent "docker" admin) ]
    then
        echo -e "\n"
        echo "+-----------------------------------+"
        echo "|  Configuration permission docker  |"
        echo "+-----------------------------------+"
        echo -e "\n"

        sudo groupadd docker
        sudo usermod -aG docker $USER
        newgrp docker
    fi
fi
    egrep -i "^docker" /etc/group;
    if [ $? -ne 0 ]
    then
        echo -e "\n"
        echo "+-----------------------------------+"
        echo "|  Configuration permission docker  |"
        echo "+-----------------------------------+"
        echo -e "\n"

        sudo groupadd docker
        sudo usermod -aG docker $USER
        newgrp docker
    fi

echo -e "\n"
echo "+---------------------------+"
echo "|  Configuration du server  |"
echo "+---------------------------+"
echo -e "\n"
read -p "Voulez vous configurer le server (N/o)" server
echo -e "\n"

if [ "$server" = "o" ]
then
    sudo cp model.env .env

    read -p "Nom de votre database : " MYSQL_DATABASE
    read -p "Nom de votre utilisateur : " MYSQL_USER
    read -sp "Mot de passe utilisateur : " MYSQL_PASSWORD
    echo
    read -sp "Mot de passe root : " MYSQL_ROOT_PASSWORD
    echo
    read -p "Port de la BDD : " MYSQL_PORT
    read -p "Port PHP : " PHP_PORT
    read -p "Port HTTP : " NGINX_PORT_HTTP
    read -p "Port HTTPS : " NGINX_PORT_HTTPS
    read -p "EMAIL GIT : " GIT_MAIL
    read -p "USERNAME GIT : " GIT_USERNAME

    DATABASE_URL="mysql://$MYSQL_USER:$MYSQL_PASSWORD@db-service:3306/$MYSQL_DATABASE?serverVersion=mariadb-10.6.4"

    sudo sed -i -e "s|\"local\"|$DATABASE_URL|" \
              -e "s|MYSQL_PORT|MYSQL_PORT=$MYSQL_PORT|" \
              -e "s|MYSQL_DATABASE|MYSQL_DATABASE=$MYSQL_DATABASE|" \
              -e "s|MYSQL_USER|MYSQL_USER=$MYSQL_USER|" \
              -e "s|MYSQL_PASSWORD|MYSQL_PASSWORD=$MYSQL_PASSWORD|" \
              -e "s|MYSQL_ROOT_PASSWORD|MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD|" \
              -e "s|PHP_PORT|PHP_PORT=$PHP_PORT|" \
              -e "s|NGINX_PORT_HTTP=|NGINX_PORT_HTTP=$NGINX_PORT_HTTP|" \
              -e "s|NGINX_PORT_HTTPS=|NGINX_PORT_HTTPS=$NGINX_PORT_HTTPS|" \
              -e "s|GIT_MAIL|GIT_MAIL=$GIT_MAIL|" \
              -e "s|GIT_USERNAME|GIT_USERNAME=$GIT_USERNAME|" \
              .env
else
    echo -e "\n"
    echo "+-----------------------------------+"
    echo "|   Si problème avec warn variable  |"
    echo "|     relancer la config server     |"
    echo "+-----------------------------------+"
    echo -e "\n"
fi

echo -e "\n"
echo "+--------------------------+"
echo "|        Run Server        |"
echo "+--------------------------+"
echo -e "\n"

sudo docker-compose build
sudo docker-compose up #-d
#sudo docker-compose exec -T php-service composer install --ignore-platform-reqs #--prefer-dist --no-scripts
#sudo docker-compose exec -T php-service php bin/console d:d:d --force --no-interaction
#sudo docker-compose exec -T php-service php bin/console d:d:c --no-interaction
#sudo docker-compose exec -T php-service php bin/console d:m:m --verbose #--no-interaction --allow-no-migration
#
#if [ "${APP_ENV}" != "prod" ]; then
#  sudo docker-compose exec -T php-service php bin/console doctrine:fixtures:load #--quiet --no-interaction --no-debug
#else
#  echo
#fi
#
echo -e "\n"
echo "+-------------------------------+"
echo "|     Votre projet est lancé    |"
echo "| Configurez votre .env Symfony |"
echo "|           si Besoin           |"
echo "+-------------------------------+"
echo -e "\n"
