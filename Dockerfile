FROM ubuntu:20.04


RUN apt-get update

RUN apt-get install -y software-properties-common

RUN apt-get install cron

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update


RUN apt-get -y install php7.3

RUN apt-get -y install php7.3-bcmath php7.3-ctype php7.3-curl php7.3-dom php7.3-gd php7.3-iconv php7.3-intl php7.3-mbstring php7.3-mysql php7.3-xml php7.3-soap php7.3-xsl php7.3-zip php7.3-fpm

RUN apt-get -y install nginx

RUN apt-get -y install composer

RUN apt-get -y install curl

RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh

RUN bash nodesource_setup.sh

RUN apt-get install nodejs && node -v && npm -v

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN npm i -g magepack

RUN mkdir /var/scripts
COPY start.sh /var/scripts/start.sh
COPY replace.js /var/scripts/replace.js
COPY themes.js /var/scripts/themes.js
# RUN bin/magento set:di:co \
#     && bin/magento set:sta:dep -f \
#     && bin/magento cache:flu \
#     && magepack bundle 



# RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
#     && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
#     && chown -R :www-data .

EXPOSE 80


CMD  mv /var/scripts/* /var/www;cd /var/www; chmod +x start.sh; ./start.sh;


