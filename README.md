# Magento2 automation using docker-compose 

## Stack

- Magento2
- Nginx
- Php-fpm7.3
- Docker
- Docker-compose
- Elastic Search
- Redis

With this image you can automate magento2 deployments with the use of docker-compose on Linux .

This guide shows how to implement the deploy using Ubuntu, but you can replicate the tutorial on any other distro.

This configuration automatically uses magepack in case you have the configuration file the resources will be optimized.

This configuration uses at minimum 8GB of RAM

### Repository

https://github.com/allexxis/magento-nginx-fpm7.3

### Before we begin 

**This guide assumes that you have already an installation of magento2 on a database so in that case you should have the following files**

env.php located on magentofolder/app/etc/env.php

config.php located on magentofolder/app/etc/config.php

###  Step #1

**Install docker on your computer or server (jump to step #2 in case you have docker)**

1. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

 ```bash
sudo apt-get update
 ```
 ```bash
 sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
 ```
2. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

3. Set up stable repository

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

4. Install docker engine

```bash
sudo apt-get update
```

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
5. Test installation
```bash
docker --version
```

### Step #2

**Install docker-compose on your computer or server (jump to step #2 in case you have docker)**

1. Download current stable version 

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
2. Apply executable permissions
```bash
sudo chmod +x /usr/local/bin/docker-compose
```

`Note: If the command docker-compose fails after installation, check your path. You can also create a symbolic link to /usr/bin or any other directory in your path.`

```bash
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

3. Test  installation

```bash
docker-compose --version
```

### Step #3 

**Copy the files within the src folder in this repo https://github.com/allexxis/magento-nginx-fpm7.3/src to you own magento2 root folder every file is required** 

1. Change environmental variables for your own variables on [docker-compose.yml](https://github.com/allexxis/magento-nginx-fpm7.3/src/docker-compose.yml) or setup environmentals on your host machine

​      \- MAGENTO_USERNAME=$MAGENTO_USERNAME (Your magento [public key](https://marketplace.magento.com/customer/accessKeys/) )

​      \- MAGENTO_PASSWORD=$MAGENTO_PASSWORD (Your magento [private key](https://marketplace.magento.com/customer/accessKeys/) )

​      \- MAGENTO_DOMAIN=$MAGENTO_DOMAIN (The domain you will use for your site **yourdomain.com** or 127.0.0.1 if using localhost)

2. Change the theme configuration on  [themes.json](https://github.com/allexxis/magento-nginx-fpm7.3/src/themes.json) 

   `Note: If you set the themes array empty []  the configuration will use  bin/magento setup:static-content:deploy -f to compile all resources`

```json
{
    "themes":[
        {
            "area":"adminhtml", //Area of deployment
            "langs":["en_US"],//You can add multiple languages here
            "name":"Magento/luma" //Name of your theme
        },{
            "area":"frontend",
            "langs":["en_US"],
            "name":"Magento/luma"
        }
    ]
}
```

3. Rename default file nginx.conf.sample to magento.nginx.conf

   

4. Change configuration on [nginx.conf](https://github.com/allexxis/magento-nginx-fpm7.3/src/nginx.conf)  in case you have installed magento2  on another folder my path is /var/www the configuration will hear port **80** and **443** by deafult;

   ```nginx
   upstream fastcgi_backend {
     server   unix:/var/run/php/php7.3-fpm.sock;
   }
   
   server {
   
     listen 80 default_server;
     listen 443;
     server_name {{MAGENTO_DOMAIN}}; # Dont't change this, automatically configuration will change it
     set $MAGE_ROOT /var/www/; #change your path here
     include /var/www/magento.nginx.conf; #update this one if the above is changed
   
     error_log /var/www/error.log; #Set your logs path
     access_log /var/www/access.log;
   }
   
   ```

5. Change configuration on [php.ini](https://github.com/allexxis/magento-nginx-fpm7.3/src/php.ini) configuration for your own php configuration if need it php fpm will take this configuration by default

   ```php
   memory_limit = 756M
   max_execution_time = 18000
   session.auto_start = off
   suhosin.session.cryptua = off
   ```

   

### Step# 4

**Deploy the configuration. Go to your root folder in my case /var/www and run**

```bash
docker-compose up
```

If you want to deploy on the background

```bash
docker-compose up -d
```

If you make a code update

```bash
docker-compose restart
```

If you need to enter the magento container

```bash
docker container exec -it magento  /bin/bash
```

In case that the magento-fpm docker image gets updated 

```bash
docker pull allexxis/magento-nginx-fpm7.3
docker-compose down
docker-compose up -d
```

### Possible errors 

Message:

- Error elasticsearch exited code 78 

Solution:

- Run the following command on the host machine

  ```bash
  sudo sysctl -w vm.max_map_count=262144
  ```

  
