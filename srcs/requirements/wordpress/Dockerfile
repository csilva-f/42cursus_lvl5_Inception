# Dockerfile responsible to build the image for the wordpress container
# we need to set up additional components manually, such as a web server (Apache or Nginx) and PHP,
# because the debian:bullseye image doesn't include these by default.

# speficies the base image for the Docker image - Debian with the Bullseye release (which is the one previous to the latest stable version)
# it sets up the starting point for building the Docker image (Debian 11)
# base image is needed because it provides the foundational environment upon which the custom Docker image will be built - OS, software packages, libraries and tools; docker images are built in layers and the base image is the initial layer
# provides a stable and mininal Debian environment; we won't setup the web server part, it will be handled by the nginx
FROM    debian:bullseye

# informs Docker that the container will be listening on port 9000 at runtime
# the word EXPOSE doesn't publish the port, it only indicates which ports are intended to be published
# allows services running inside the container to be accessible outside of it (such as the PHP-FPM)
# informs docker compose about the ports that need to be connected between containers
EXPOSE	9000

# defines a build-time variables which set the version and path to the PHP-FPM configuration directory
ARG		PHP_VERSION=7.4
ARG		PHPPATH=/etc/php/${PHP_VERSION}/fpm

# Installation of the necessary packages: PHP and its dependencies 
# apt update: updates the package index inside the Docker image - ensures latest version of the packages
# apt install -y ..: installs the specified server packages without recommended or suggested packages
# ca-certificates: adds Certificate Authority (CA) certificates to verify SSL connections;
# this package manages SSL certificates and is a good practice to have it installed
# php7.4-fm: installs PHP-FPM 7.4, which is essential for serving PHP files and running PHP applications like Wordpress
# php7.4-mysql: installs PHP MySQL module for database connectivity, to support PHP, allowing it yo communicate with MySQL databases. It is necessary for WordPress to interact with MariaDB
# wget: installs wget, a tool for downloading files from the web via HTTP, HTTPS and FTP protocols. In this Dockerfile it's used to download WordPress and potentially other resources
# tar: installs tar (Tape Archive), a tool for extracting and creating tar archives for files. In this Dockerfile it;t used to extract the downloaded WordPress archive (latest.tar.gz)
# rm -rf ...: cleans up the package cache to reduce the image size
# apt-get clean: removes all cached .deb packages from the local rep cache

# FPM = FastCGI Process Manager;
# CGI (Common Gateway Interface) is a standard protocol that defines how web servers communicate with external programs or scripts to generate dynamic web content or perform other server-side tasks.
# FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation that offers several advantages over and more efficiency then traditional CGI-based methods

RUN		apt update && apt install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-mysql \
		wget \
		tar && \
		rm -rf /var/lib/apt/lists/* \
		&& apt-get clean

# copies the configuration file to the container's php folder 
# ensures that PHP-FPM is configured correctly. This step is crucial for tuning PHP-FPM’s behavior and settings
# the www.conf file is part of the PHP-FPM configuration and is typically located in the pool.d directory (or similar) within the PHP installation directory.
COPY	conf/www.conf ${PHPPATH}/pool.d/

# downloads the WP-CLI PHP Archive file from the web, without checking the SSL certificate of the URL
# changes the permissions of the downloaded file in order to make it executable
# moves the file to the indicated directory, making it accessible system-wide as a command
RUN		wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

# Ensures that required directories exist for PHP-FPM and WordPress operations and changes its owner to www-data user, ensuring that WordPress files can be read and written by the PHP-FPM process securely.
#The www-data user and group are commonly used by web servers (like Nginx) to run web applications.
# changes the ownership of the directory and its contents (-R) to the www-data user and group, which is the default user for web servers like Apache and Nginx
RUN     mkdir -p /run/php/ /var/run/php/ /var/www/ince/ \
        && chown -R www-data:www-data /var/www/ince/

# copies the wp-config.php and init.sh files to the container and changes their permissions
# it prepares the container for configuring and running WordPress upon startup
COPY    ./conf/wp-config.php /var/www/ince/
COPY    ./tools/init.sh /bin/

#Give the initialization script permisssion to executed by user
RUN     chmod 755 /bin/init.sh

# runs the init.sh script when the container starts
# then starts the php.fpm7.4 in the foreground - PHP FastCGI Process Manager, a daemon that manages FastCGI processes for handling PHP requests.
# --nodaemonize: tells php-fpm7.4 to run in the foreground rather than as a background daemon (common practice, allows the container to stay alive as long as the main process is running; when the main process runs in the foreground, Docker can manage the container lifecycle based on the status of that process; if the process stops, the container will stop)
CMD		["/bin/init.sh", "php-fpm7.4", "--nodaemonize"]
