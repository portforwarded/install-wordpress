#!/bin/bash

echo "Enter a username for MySQL database: "
read username
echo "Enter a password for MySQL database: "
read password

# Set the temporary directory for sed
export TMPDIR=/tmp

# Install Apache, MySQL, and dependencies
sudo apt update -y
sudo apt install apache2 ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml php-zip -y

# Create directory to host WP files
sudo mkdir -p /var/www/html
#sudo mkdir -p /var/www/.local/share/nano
sudo chown www-data: /var/www/html
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /var/www/html

# Create HTTP configuration
sudo touch /etc/apache2/sites-available/wordpress.conf
sudo tee /etc/apache2/sites-available/wordpress.conf << EOF
<VirtualHost *:80>
    DocumentRoot /var/www/html/wordpress
    <Directory /var/www/html/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /var/www/html/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Enable WP site
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo a2dissite 000-default

# Create database, admin user, grant privs, start database service
sudo mysql -u root -e "CREATE DATABASE wordpress; CREATE USER $username@localhost IDENTIFIED BY '$password'; GRANT ALL PRIVILEGES ON wordpress.* TO $username@localhost; FLUSH 
PRIVILEGES;"
sudo service mysql start

# Create and edit the wordpress config file
sudo -u www-data cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo -u www-data sed -i "s/database_name_here/wordpress/" /var/www/html/wordpress/wp-config.php
sudo -u www-data sed -i "s/username_here/$username/" /var/www/html/wordpress/wp-config.php
sudo -u www-data sed -i "s/password_here/$password/" /var/www/html/wordpress/wp-config.php

# set wp-config.php file path
wp_config="/var/www/html/wordpress/wp-config.php"

# Fetch the secret keys from the URL and write them to site-keys.txt
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > site-keys.txt

site_keys_file="site-keys.txt"

# Read the values from the file into an array
readarray -t values < "$site_keys_file"

# Function to escape special characters in a string
escape_special_chars() {
  echo "$1" | sed 's/[\/&]/\\&/g'
}

# Use a loop to replace lines 51 to 58 in the wp-config.php file
for i in {0..7}; do
    line_number=$((51 + i))
    escaped_value=$(escape_special_chars "${values[$i]}")
    sed -i "${line_number}s/.*/${escaped_value}/" "$wp_config"
done

# The values to replace for lines 23, 26, and 29
db_name="wordpress"
db_user="$username"
db_password="$password"

# Use sed with sudo -u www-data to edit the file with www-data user privileges
sudo -u www-data bash -c "sed -i \"s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '$db_name' );/\" \"$wp_config\""
sudo -u www-data bash -c "sed -i \"s/define( 'DB_USER', '.*' );/define( 'DB_USER', '$db_user' );/\" \"$wp_config\""
sudo -u www-data bash -c "sed -i \"s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '$db_password' );/\" \"$wp_config\""

# Install phpMyAdmin and dependencies, restart Apache
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
sudo phpenmod mbstring
sudo a2enmod headers
sudo systemctl reload apache2
sudo systemctl restart apache2

# Remove the key file
sudo rm site-keys.txt
echo "phpMyAdmin configured, Apache server restarted."
echo "Congratulations! Welcome to Wordpress!"
