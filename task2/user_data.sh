#!/bin/bash
 
# Update and upgrade the system
apt update -y
apt upgrade -y

# Install Apache, PHP, MySQL
apt install apache2 -y
apt install php libapache2-mod-php php-mysql -y
apt install mysql-server unzip wget -y

# Configure MySQL - secure and setup DB/user
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'T@sk2forCE';
CREATE USER 'haider_wp'@'localhost' IDENTIFIED BY 'T@sk2forCE';
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'haider_wp'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress /var/www/html/

# Set permissions
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Update Apache config
sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/wordpress|g' /etc/apache2/sites-available/000-default.conf

# Restart Apache
systemctl restart apache2

# Configure wp-config.php
cd /var/www/html/wordpress
cp wp-config-sample.php wp-config.php

# Update database details in wp-config.php
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/haider_wp/" wp-config.php
sed -i "s/password_here/T@sk2forCE/" wp-config.php

# Done!
echo "WordPress installation and configuration completed successfully."