#!/bin/bash

# the first line is the shebang tells the system that this script should be executed using Bash shell

# this file script automates the setup and configuration tasks required to prepare the service inside the container; ensures the environment is correctly set up each time the container starts
# by automating the initialization steps, the script ensures the container env is consistent and reproducible accross different deployments
# can read env variables and use them to configure the service, allowing the same container image to be used in multiple environments with different configurations
# this script integrates with the container's CMD instruction to run the main application process after the initialization steps are completed, ensuring that the application starts in a properly configured state

#DOMAIN=csilva-f.42.fr
#DOMAIN_NAME=csilva-f
#COUNTRY=PT
#STATE=PT
#LOCALITY=PORTO
#ORGANIZATION=42
#UNIT=PORTO

# Defines the path where the SSL certificate ($DOMAIN.csr and $DOMAIN.key) will be stored
certify_path="/etc/ssl/private/$DOMAIN"

# Creates the directory if it doesn't exist
mkdir -p /etc/ssl/private

# Generate the SSL certificate and key: This command generates a self-signed certificate (-x509) valid for 365 days (-days 365), 
# using a new RSA private key (-newkey rsa:2048). The certificate's subject (-subj) is specified with the variables, ensuring it accurately reflects your organization's identity.
# openssl: command-line tool for the OpenSSL library, which provides various cryptographic operations
# req: specifies that we want to use the "certificate request and certificate generating utility" in OpenSSL. This utility can be used to create a certificate signing request (CSR) or, in this case, a self-signed certificate.
# using a self-signed certificate is primarily useful in situations where you need to encrypt data over HTTPS (HTTP Secure) but don't require third-party validation or where setting up a full certificate authority (CA) infrastructure isn't feasible or necessary
# -x509: to generate a self-signed certificate instead of a certificate signing request (CSR); the X.509 standard defines the format of public key certificates.
# -nodes: no DES (Data Encryption Standard): the key will not be encrypted with a passphrase, which is practical for automated scripts.
# -days 365: the validity period of the certificate
# -newkey rsa:2048: generates a new private key using the RSA algorithm with a key size of 2048 bits
# -keyout $certify_path.key: specifies the filename where the private key will be saved.
# -out $certify_path.crt
# -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$DOMAIN: sets up the details in the certificate
# these components are crucial in certificate validation. When a client (such as a web browser) connects to a server secured with SSL/TLS, it verifies the details in the certificate to ensure it's connecting to the intended server
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $certify_path.key -out $certify_path.crt \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$DOMAIN"

# sed: stream editor; replaces occurences of $DOMAIN in nginx configuration file with the actual domain name stored in the $DOMAIN variable
sed -i "s/\$DOMAIN/$DOMAIN/g" /etc/nginx/sites-available/default

# checks the syntax of the nginx config without actually starting nginx
nginx -t

# starts nginx and runs it in the foreground - the process will not detach from the terminal and will keep running in the current session
nginx -g 'daemon off;'
