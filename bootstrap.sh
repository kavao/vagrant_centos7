#!/usr/bin/env bash

# kitting batch for centos7  2015/5
#
# ex.  http://blogs.zealot.co.jp/archives/176

echo "Bootstrap Script start."

# Exit if already bootstrapped
test -f /home/bootstrapped && exit

# date
sudo timedatectl set-timezone  Asia/Tokyo

# yum update
sudo /usr/bin/yum -y update --exclude=kernel*


# directory setup
sudo mkdir /var/www/public

# firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# selinux
sudo sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# epel
sudo yum -y install epel-release

# httpd
sudo yum -y install httpd

sudo rm -f /etc/httpd/conf.d/welcome.conf

sudo cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig
sudo sed -i -e 's@DocumentRoot "/var/www/html"@DocumentRoot "/var/www/public"@g' /etc/httpd/conf/httpd.conf
sudo sed -i -e 's@<Directory "/var/www/html">@<Directory "/var/www/public">@g' /etc/httpd/conf/httpd.conf
sudo sed -i -e 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf
sudo sed -i -e 's/DirectoryIndex index.html/DirectoryIndex index.html index.php/g' /etc/httpd/conf/httpd.conf

sudo sh -c "echo 'ServerTokens Prod' >> /etc/httpd/conf/httpd.conf"
sudo sh -c "echo 'KeepAlive On' >> /etc/httpd/conf/httpd.conf"

sudo mkdir /var/www/public
sudo chmod 777 /var/www/public

# php
sudo yum -y install --enablerepo=epel php php-mbstring php-pear php-mysqlnd php-gd php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-soap php-tidy
sudo yum -y install php-pecl-zendopcache.x86_64
sudo cp -p /etc/php.ini /etc/php.ini.orig
sudo sed -i -e 's@;date.timezone =@date.timezone = "Asia/Tokyo"@g' /etc/php.ini

sudo systemctl start httpd
sudo systemctl enable httpd

# composer
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# mariadb
sudo yum -y install mariadb mariadb-server
sudo cp -p /etc/my.cnf /etc/my.cnf.orig
sudo sed -i -e '/^\[mysqld\]$/a character-set-server=utf8' /etc/my.cnf

sudo systemctl start mariadb
sudo systemctl enable mariadb

# mariadb user:forge / database:forge
mysql -uroot -e \
"select user,host,user from mysql.user;\
CREATE DATABASE forge;\
grant all on forge.* to forge@localhost identified by '';"


# finish
sudo date > /home/bootstrapped

# vbox update
sudo /etc/init.d/vboxadd setup



# reboot
#reboot
