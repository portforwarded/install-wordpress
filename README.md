This script will install Wordpress, MySQL, PHP, and phpMyAdmin (for database administration).

To run the script, make it executable with:

sudo chmod +x install-wordpress.sh

Then run with:

sudo ./install-wordpress.sh

The script will prompt you to enter a username and password for administrative access to the MySQL database and phpMyAdmin. Be sure to write them down! This is not the username and password you will create for administrative access to the WordPress login page. You will create those when finalizing the WordPress installation. 

Once Wordpress is installed, navigate to http://localhost or the IP on your network (or public IP) where you installed Wordpress

Follow the prompts to finish installation. 

This installation doesn't include setting up an SSL certificate or any security-related modules. This is a bare-bones
install and configuration.
