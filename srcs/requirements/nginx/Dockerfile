# Dockerfile responsible to build the image for the nginx container
# we need to set up additional components manually, such as a web server (Apache or Nginx) and PHP, because the debian:bullseye image doesn't include these by default.

# speficies the base image for the Docker image - Debian with the Bullseye release (which is the one previous to the latest stable version)
# it sets up the starting point for building the Docker image (Debian 11)
# base image is needed because it provides the foundational environment upon which the custom Docker image will be built - OS, software packages, libraries and tools; docker images are built in layers and the base image is the initial layer
# provides a stable and mininal Debian environment; we won't setup the web server part, it will be handled by the nginx
FROM	debian:bullseye

# informs Docker that the container will be listening on port 9000 at runtime
# the word EXPOSE doesn't publish the port, it only indicates which ports are intended to be published
# informs docker compose about the ports that need to be connected between containers
# EXPOSE	443

# installs nginx (open source web server software used for reverse proxy, load balancing and caching) and openssl (open-source command line tool used to generate private keys, instal SSL/TLS certificates and identify certificate info)
# then removes unnecessary files to reduce the Docker image size
# flags like --no-install-recommends and --no-install-suggests ensure only essential packages are installed
RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		rm -rf /var/lib/apt/lists/* && \
		apt-get clean

# copies the init script from tools to the temporary directory
# copies the server.conf file to the specified folder
COPY	tools/init.sh		/tmp/init.sh
COPY	conf/server.conf	/etc/nginx/available-sites/default

# sets permissions to read, write and execute the init file copied to the temporary directory
RUN		chmod 755 /tmp/init.sh

# specifies the commands to run when the container starts
CMD		["/tmp/init.sh"]
