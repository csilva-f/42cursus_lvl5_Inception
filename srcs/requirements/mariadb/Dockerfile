# Dockerfile responsible to build the image for the mariadb container

# speficies the base image for the Docker image - Debian with the Bullseye release (which is the one previous to the latest stable version)
# it sets up the starting point for building the Docker image (Debian 11)
# base image is needed because it provides the foundational environment upon which the custom Docker image will be built - OS, software packages, libraries and tools; docker images are built in layers and the base image is the initial layer
# https://www.debian.org/releases/
FROM	debian:bullseye

# informs Docker that the container will be listening on port 3306 at runtime
# the word EXPOSE doesn't publish the port, it only indicates which ports are intended to be published
# allows services running inside the container to be accessible outside of it; informs docker compose about the ports that need to be connected between containers
EXPOSE	3306

# runs shell commands inside the Docker image
# apt update: updates the package index inside the Docker image - ensures latest version of the packages
# apt install -y ..: installs mariadb server package without recommended or suggested packages
# rm -rf ...: cleans up the package cache to reduce the size of the Docker image
RUN		apt update && \
		apt install -y --no-install-recommends --no-install-suggests \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

# creates the directory /var/run/mysqld;
# -p: tells mkdir to create the directory and any necessary parent directories if they do not already exist; this directory is needed in the image, so that mariadb is able to store runtime files such as PID files and sockets
# the next line changes the ownership of the /var/run/mysqld and /var/lib/mysql to the mysql user and group;
# -R: means recursive, applies the ownership change to the directory and all its contents, so that the mysql has the necessary permissions to read, write, and execute files in this directory
# /var/lib/mysql is where mariadb stores its database files
# this part is needed because mariadb needs to access the runtime directory to create and manage files such as the socket file, or it may fail to start;
# running mariadb under mysql user instead of the root user adheres to the principle of least privilege, reducing the risk of security vulnerabilities, preventing unauthorized access
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

# copies a configuration file into the Docker image
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# copies the initialization shell script into the Docker image
COPY	tools/init.sh /bin/

# changes the permissions of the init.sh script file to make it executable inside the Docker image
RUN		chmod +x /bin/init.sh

# specifies the command to run when the container is started from this image
# init.sh: executes the initialization script
# mysqld_safe: starts mariadb in a safe mode, typically used to start mariadb within Docker containers
CMD		["init.sh", "mysqld_safe"]
