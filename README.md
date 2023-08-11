This script will install Wordpress, MySQL, PHP, and phpMyAdmin (for database administration).

PLEASE NOTE: change the default user and password for phpMyAdmin

user: admin
password: default

To run the script, make it executable with:

sudo chmod +x install-wordpress.sh

Then run with:

sudo ./install-wordpress.sh

Once Wordpress is installed, navigate to http://localhost or the IP on your network where you installed Wordpress

Follow the prompts to finish installation. 

This installation doesn't include setting up an SSL certificate or any security-related modules. This is a bare-bones
install and configuration.
