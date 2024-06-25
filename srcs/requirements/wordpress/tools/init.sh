#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations
# this script integrates with the container's CMD instruction to run the main application process after the initialization steps are completed, ensuring that the application starts in a properly configured state

# WP_URL=login.42.fr
# WP_TITLE=Inception
# WP_ADMIN_USER=wppoweruser
# WP_ADMIN_PASSWORD=123456
# WP_ADMIN_EMAIL=wppoweruser@email.com
# WP_USER=wpuser
# WP_PASSWORD=123456
# WP_EMAIL=wpuser@email.com
# WP_ROLE=editor

# checks if the wp-config.php file exists in the /var/www/ince. If not it copies it, so that the container can access the WordPress configuration settings (DB connection details, authentication, etc.); ensures that the config file is included inside the container; can run multiple times withou causing any trouble for the WordPress functioning
if [ ! -f /var/www/ince/wp-config.php ]; then
    echo "WordPress configuration file not found!"
    exit 1
fi

# there may be a delay for the DB availability (specially in dynamic environments like Docker containers); allows MariaDB to start up and become ready to accept containers
# # it is only for safety reasons, not mandatory, so that the script does not attempt to connect to the database before it is fully ready
sleep 10

# downloads WordPress core files to /var/www/ince/ if they are not already there
# the true in the end ensures that even if the download fails, the script will continue executing (meand ignore errors and continue execution)
# the script should not terminate abruptly
# the download is indispensible for the setup because it initiates WordPress installation, providing essential core files and enabling subsequent steps to configure and complete the setup within the docker environment effectively
wp --allow-root --path="/var/www/ince/" core download || true

# installs WordPress if it is not already installed, using the needed env variables
# the condition uses the WP-CLI to chek if WP is installed in the specified path
# --allow-root: allows the WP-CLI commands to be run as the root user
# --path: specifies the path to the WP installation
# core is-installed: checks if WP is installed by verifying if the necessary files and configurations are present
# if not, it proceeds with its installation, 'core install'
# --url, --title, --admin_user, ...: sets the URL, title, admin user, etc. values of the WP site to the values of the env variables
# this part in crucial because it ensures idempotence - no matter how many times the script is ran, the result will always be the same, not causing any unintended side effects or redundant operations;
# guarantees that the WP is installed and configured correctly each time the container starts
if ! wp --allow-root --path="/var/www/ince/" core is-installed ; then
    wp  --allow-root --path="/var/www/ince/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

# this section is responsible for the WP user creation, in case it does not already exist
# it first checks if the WP user with the provided username (env variable) exists
# how? it attemps to retrieve the user info according to the given username
# if it does not exist, the it proceeds with its creation, setting its username, email, password and role
# having a user for WP is important to allow logging into WP admin dashboard and manage the website, its security and enabling content
# without a user, it would not be possible to perform all this tasks on the website
if ! wp --allow-root --path="/var/www/ince/" user get $WP_USER ; then
    wp  --allow-root --path="/var/www/ince/" user create \
        $WP_USER \
        $WP_EMAIL \
        --role=$WP_ROLE \
        --user_pass=$WP_PASSWORD
fi;

# runs the next command specified in the Dockerfile's CMD instruction
exec $@
