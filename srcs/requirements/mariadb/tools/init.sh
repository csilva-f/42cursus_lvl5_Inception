#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations
# allows starting the database, and sets up its databases, users and permissions, loading initial data and configurations
# this script integrates with the container's CMD instruction to run the main application process after the initialization steps are completed, ensuring that the application starts in a properly configured state

# this line, if uncommented, enables the debug mode, making the script print each command executing it and exit if any of it returns a non-zero status
# set -ex # print commands & exit on error (debug mode)

# DB_NAME=maria
# DB_USER=umaria
# DB_PASSWORD=abc
# DB_PASS_ROOT=cba

# starts the mariadb within the container and ensures it is running so that the subsequent commands can interact with the database
service mariadb start

# automated setup and configuration of MariaDB inside a Docker container
# it checks if the directory alredy exists; if so, it performs several security-related tasks to ensure a fresh MariaDB installation
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
mysql_secure_installation << EOF
$WP_ADMIN_PASS
y
n
y
y
y
y
EOF
fi

# 1: starts a MySQL/MariaDB client session (mariadb) with the root user, then opens a heredoc to input multiple lines until the EOF encounter
# 2: creates the DB with the stored name from env, if it does not already exist
# 3: creates the DB user with the stored varible from en, if it does not already exist
# 4: grants all DB privileges to the DB user with the respective password stored in env
# 5: grants all DB privileges to the root user with the respective password stored in env
# 6: sets the password for the root user with the value stored in env  specifically when connecting from localhost; enforces authentication for admin access to the DB server, so this way not everyone can access to the system
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
FLUSH PRIVILEGES;
EOF

# pauses execution of the script, so that it allows time for the DB operations initiatedi by the mariadb client to complete before stopping the service
sleep 5

# stops the mariadb service; it is a good practice to stop services after initial setup to ensure they can restart cleanly when the container starts again
service mariadb stop

# executes the command passed to the script as argument (specified by CMD). Replaces the current shell process with the specified comman, which is efficient and ensures that signals are correctly passed to the main process
exec $@ 
