This script will install Wordpress, MySQL, PHP, and phpMyAdmin (for database administration).

The script will prompt you to enter a username and password for administrative access to the MySQL database. Be sure to write them down! These is not the username and password you will create for administrative access to the front-end login page - you will create that when finalizing the WordPress installation. 

To run the script, make it executable with:

sudo chmod +x install-wordpress.sh

Then run with:

sudo ./install-wordpress.sh

Once Wordpress is installed, navigate to http://localhost or the IP on your network (or public IP) where you installed Wordpress

Follow the prompts to finish installation. 

This installation doesn't include setting up an SSL certificate or any security-related modules. This is a bare-bones
install and configuration.
