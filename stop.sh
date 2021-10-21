sudo true

read -p "Voulez-vous stopper et reset le server ? (N/o) : " stop

sudo docker-compose down

if [ $stop = 'o' ]
then
    sudo docker system prune -a
fi

sudo docker ps
sudo docker images

echo -e "\n"
echo "+--------------------------+"
echo "|        Server Down       |"
echo "+--------------------------+"
echo -e "\n"