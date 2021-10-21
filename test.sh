sudo cp model.env .env

read -p "Nom de votre database : " MYSQL_DATABASE
read -p "Nom de votre user : " MYSQL_USER
read -p "Mot de passe : " MYSQL_PASSWORD
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
            -e "s|PHP_PORT|PHP_PORT=$PHP_PORT|" \
            -e "s|NGINX_PORT_HTTP=|NGINX_PORT_HTTP=$NGINX_PORT_HTTP|" \
            -e "s|NGINX_PORT_HTTPS=|NGINX_PORT_HTTPS=$NGINX_PORT_HTTPS|" \
            -e "s|GIT_MAIL|GIT_MAIL=$GIT_MAIL|" \
            -e "s|GIT_USERNAME|GIT_USERNAME=$GIT_USERNAME|" \
            .env.local