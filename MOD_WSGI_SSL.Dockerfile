# export CERTIFICATE_PASSWORD=<PASSWORD>
# export CERTIFICATE_NAME=<PFX_FILE_NAME>
# export BASIC_USER=<ADMIN_USER_NAME>
# export BASIC_USER_PASSWORD=<ADMIN_USER_PASSWORD>

FROM python:3.7-slim-buster
ARG CERTIFICATE_PASSWORD
ARG CERTIFICATE_NAME
ARG BASIC_USER
ARG BASIC_USER_PASSWORD
ARG WSGI_USER
ARG WSGI_USER_PASSWORD

MAINTAINER denis.patrakhin@gmail.com

ENV APACHE_VERSION=2.4.38-3+deb10u3\
    MOD_WSGI_VERSION=4.7.1

COPY install.sh /usr/local/bin/mod_wsgi-docker-install
RUN /usr/local/bin/mod_wsgi-docker-install

COPY setup.sh /usr/local/bin/mod_wsgi-docker-setup
COPY ${CERTIFICATE_NAME}.pfx /tmp
RUN /usr/local/bin/mod_wsgi-docker-setup

COPY configure.sh /usr/local/bin/mod_wsgi-docker-configure-apache
COPY apps.list /tmp/apps.list
COPY requirements.txt /tmp/requirements.txt
RUN /usr/local/bin/mod_wsgi-docker-configure-apache

COPY entrypoint.sh entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV MOD_WSGI_USER=$WSGI_USER MOD_WSGI_GROUP=root

WORKDIR /app

CMD ["/entrypoint.sh"]
