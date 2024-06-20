#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations

# Defines the path where the SSL certificate ($DOMAIN.csr and $DOMAIN.key) will be stored
certify_path="/etc/ssl/private/$DOMAIN"

# openssl req: generates a self-signed X.509 certificate
# -x509: specifies a self-signed certificate (signed by its own creator rather than a trusted certificate authority
# -nodes: does not encrypt the private key (no data encryption standard)
# -out $certify_path.csr: specifies the output file for the certificate signing request
# -keyout $certify_path.key: specifies the output file for the private key
# -subj: subject of the certificate with various fields taken from env variables
openssl req -x509 -nodes -out $certify_path.csr -keyout $certify_path.key \
            -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/$UNIT=42/CN=$DOMAIN/UID=$DOMAIN_NAME"

# sed: stream editor; replaces occurences of $DOMAIN in nginx configuration file with the actual domain name stored in the $DOMAIN variable
sed -i "s/\$DOMAIN/$DOMAIN/g" /etc/nginx/sites-available/default

# checks the syntax of the nginx config without actually starting nginx
nginx -t

# starts nginx and runs it in the foreground - the process will not detach from the terminal and will keep running in the current session
nginx -g "daemon off;"
