#!/bin/sh

SITE_NAME="nospheratu";
DOCUMENT_ROOT="/var/www/html/$SITE_NAME/";

sudo apt-get update;
echo "############ Instalando apache ############";
sudo apt-get install -y apache2;
echo "############ Instalando git ############";
sudo apt-get install -y git;
echo "############ Instalando hiphop ############";
sudo apt-get install -y hhvm;
echo "############ Instalando beanstalkd ############";
sudo apt-get install -y beanstalkd;
echo "############ Instalando postgresql ############";
sudo apt-get install -y postgresql;
echo "############ Instalando rabbitmq ############";
sudo apt-get install -y rabbitmq;
echo "############ Instalando elasticsearch elasticache ############";
sudo apt-get install elasticsearch elasticache;
echo "############ Instalando solr ############";
sudo apt-get install solr-tomcat solr-common solr-jetty
echo "########## Instalando nano #############"
sudo apt-get install -y nano;
echo "########## Instalando vim ##############"
sudo apt-get install -y vim;
echo "########## Instalando subversion #######"
sudo apt-get install -y subversion;
echo "########## Instalando htop ##############"
sudo apt-get install -y htop;
echo "############ Instalando curl ############";
sudo apt-get install -y curl;
echo "############ Instalando php modules ############";
sudo apt-get install -y php5-cli php5-curl php-gd php5-ldap php5-mcrypt php5-mssql php5-odbc php5-intl php5-mysql;
echo "############ Instalando php ############";
sudo apt-get install -y php5;
echo "############ Instalando python ############";
sudo apt-get install -y python python-django;
echo "############ Instalando mongo ############";
sudo apt-get install -y mongodb;
echo "############ Instalando libapache2-mod-php5 ############";
sudo apt-get install -y libapache2-mod-php5;

echo "############ Criando VirtualHost Apache ############"
echo "
<VirtualHost *:80>
    ServerName $SITE_NAME.local
    DocumentRoot $DOCUMENT_ROOT
    <Directory $DOCUMENT_ROOT>
        DirectoryIndex index.php
        AllowOverride All
        Order allow,deny
        Allow from all
        <IfModule mod_rewrite.c>
            Options -MultiViews

            RewriteEngine On
            #RewriteBase /path/to/app
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^ index.php [QSA,L]
        </IfModule>
    </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/${SITE_NAME}.conf;

echo "############ Habilitando Rewrite Mode ############"
a2enmod rewrite;
echo "############ Desabiliando VirtualHost padrão ############"
a2dissite 000-default;
echo "############ Habilitando VirtualHost do projeto ############"
a2ensite ${SITE_NAME};
echo "############ Reiniciando servidor Apache ############"
service apache2 restart;
echo "############ Entra no diretório do projeto ############"
cd ${DOCUMENT_ROOT};
echo "############ Baixa o composer utilizando o Curl ############"
curl -Ss https://getcomposer.org/installer | php;
sudo mv composer.phar /usr/bin/composer;
echo "############ Executa o composer do projeto ############"
composer install;
echo "############ Instalando Mysql-Server ############"
export DEBIAN_FRONTEND=noninteractive;
sudo -E apt-get -q -y install mysql-server;
sudo service mysql restart;
echo "############ Trocando a senha do Mysql ############"
sudo mysqladmin -uroot password root;
echo "############ Criando banco ${SITE_NAME}############"
mysql -uroot -proot -e 'CREATE DATABASE $SITE_NAME CHARSET utf8'

echo "** [AGENDA] http://agenda.local:8888 **";
