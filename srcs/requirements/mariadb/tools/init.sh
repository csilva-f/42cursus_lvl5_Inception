#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations
# allows starting the database, and sets up its databases, users and permissions, loading initial data and configurations
# this script integrates with the container's CMD instruction to run the main application process after the initialization steps are completed, ensuring that the application starts in a properly configured state

# DB_NAME=maria
# DB_USER=umaria
# DB_PASSWORD=123456
# DB_PASS_ROOT=123456

#export DB_PASSWORD=$(cat /run/secrets/db_password)
#export DB_PASSWORD_ROOT=$(cat /run/secrets/db_root_password)

# starts the mariadb within the container and ensures it is running so that the subsequent commands can interact with the database
service mariadb start

# Wait for the service to start properly
sleep 5

# 1: starts a MySQL/MariaDB client session (mariadb) with the root user, then opens a heredoc to input multiple lines until the EOF encounter
# -v: verbose mode, which means it will show more detailed output
# -u: flag associated with the specification of a user
# 2: creates the DB with the stored name and respective password from env, if it does not already exist
# 3: creates the DB user with the stored varibles from env, if it does not already exist
# 5: grants all DB privileges to the DB user according to its assigned password
# 6: grants all DB privileges to the DB root user according to its assigned password
# 7: password setting for the root user to access the DB
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASSWORD_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASSWORD_ROOT');
EOF

# pauses execution of the script, so that it allows time for the DB operations initialize by the mariadb client, so that they complete before stopping the service
sleep 10

# stops the mariadb service; it is a good practice to stop services after initial setup to ensure they can restart cleanly when the container starts again
service mariadb stop

# executes the command passed to the script as argument (specified by CMD). Replaces the current shell process with the specified comman, which is efficient and ensures that signals are correctly passed to the main process
exec $@ 
