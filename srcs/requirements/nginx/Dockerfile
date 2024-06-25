# Dockerfile responsible to build the image for the nginx container

# speficies the base image for the Docker image - Debian with the Bullseye release (which is the one previous to the latest stable version)
# it sets up the starting point for building the Docker image (Debian 11)
# base image is needed because it provides the foundational environment upon which the custom Docker image will be built - OS, software packages, libraries and tools; docker images are built in layers and the base image is the initial layer
# https://www.debian.org/releases/
FROM debian:bullseye

# informs Docker that the container will be listening on port 443 at runtime
# the word EXPOSE doesn't publish the port, it only indicates which ports are intended to be published
# allows services running inside the container to be accessible outside of it; informs docker compose about the ports that need to be connected between containers
EXPOSE 443

# updates the available packages and their versions
# installs the nginx webserver and the openssl toolkit for Secure Sockets Layer and Transport Layer Security protocols
# the installation runs without installing any recommended or suggested additional package or dependencies
# in the end, it removes all files and directories obtained from the package list files, saving space in the Docker image not needed anymore after the installation
# and removing the local repository of the retrieved package files
RUN apt -y update && \
	apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean

# Copies the initialization script and NGINX configuration files to the container so they are available to use
COPY ./tools/init.sh /tmp/init.sh
COPY ./conf/server.conf /etc/nginx/sites-available/default

# Makes the initialization script executable, by changing its permissions
RUN chmod 755 /tmp/init.sh

# specifies the commands to run when the container starts
CMD ["/tmp/init.sh"]
