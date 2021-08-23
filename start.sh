#!/bin/bash


#Create Credentials
echo "{\"http-basic\":{\"repo.magento.com\":{\"username\":\"${MAGENTO_USERNAME}\",\"password\":\"${MAGENTO_PASSWORD}\"}}}" > auth.json

#Install magento packages
composer install

#Give magento execution permission
chmod +x bin/magento

#Compile resources
bin/magento set:up 
bin/magento set:di:co
rm -rf pub/static/frontend pub/static/adminhtml/
bin/magento set:sta:dep es_CR en_US -f


#Bundle reources to improve loads
magepack bundle 

#Clean cache
bin/magento cache:flu


#Give nginx new file permisssions
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R :www-data .

#Run web server
service php7.3-fpm start
service nginx start


#Run forever
tail -f /dev/null