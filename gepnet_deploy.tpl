#!/usr/bin/env bash

sudo yum install git -y
sudo yum install httpd php php-pdo php-pgsql php-xml -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install postgresql -y

sudo git clone ${GEPNET_REPOSITORY} /usr/local/gepnet
sudo rm -rf /var/www/html
sudo ln -s /usr/local/gepnet/public/ /var/www/html
sudo chown apache:apache /usr/local/gepnet/ -R


sudo sed -i "/AllowOverride /c\AllowOverride All" /etc/httpd/conf/httpd.conf


sudo sed -i "/resources.db.params.host /c\resources.db.params.host=\"${DB_HOST}\"" /usr/local/gepnet/application/configs/application.ini
sudo sed -i "/resources.db.params.host /c\resources.db.params.username=\"${DB_USER}\"" /usr/local/gepnet/application/configs/application.ini
sudo sed -i "/resources.db.params.password /c\resources.db.params.password=\"${DB_PASSWORD}\"" /usr/local/gepnet/application/configs/application.ini
sudo sed -i "/resources.db.params.dbname /c\resources.db.params.dbname=\"${DB_NAME}\"" /usr/local/gepnet/application/configs/application.ini

sudo sed -i "/CREATE DATABASE gepnet_software_publico/d" /usr/local/gepnet/docs/gepnet_softlivre_novo.sql
sudo sed -i "/ALTER DATABASE gepnet_software_publico OWNER TO postgres/d" /usr/local/gepnet/docs/gepnet_softlivre_novo.sql

sudo echo "*:5432:${DB_NAME}:${DB_USER}:${DB_PASSWORD}" > /root/.pgpass
sudo chmod 0600 /root/.pgpass
sudo psql -f /usr/local/gepnet/docs/gepnet_softlivre_novo.sql --host ${DB_HOST} --port 5432 --username ${DB_USER} --dbname ${DB_NAME}

systemctl restart httpd
