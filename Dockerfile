FROM debian:9.6

RUN apt-get update
RUN apt-get install -y dos2unix wget openssh-server vim sudo apache2 mysql-server mysql-client ca-certificates libapache2-mod-php7.0  php7.0 php7.0-cli php7.0-mbstring php7.0-gd php7.0-imap php7.0-ldap php7.0-mysql php7.0-xmlrpc php7.0-snmp php7.0-curl
RUN apt-get autoremove
RUN apt-get clean

ENV VOL_DIR=/etc/helpdesk
ENV SSL_DIR=${VOL_DIR}/ssl

ARG GUEST_PASSWD=123456
ARG GUEST_LOGIN=guest
ARG SRV_NAME=localhost.com

RUN mkdir -p ${VOL_DIR}
RUN mkdir -p ${SSL_DIR}
RUN mkdir -p .cache

COPY ./tools/start-packages /usr/local/bin/start-packages
RUN dos2unix /usr/local/bin/start-packages \
    && chmod +x /usr/local/bin/start-packages

# COPY ./tools/create-certs /usr/local/bin/create-certs
# RUN dos2unix /usr/local/bin/create-certs \
#     && chmod +x /usr/local/bin/create-certs

COPY ./apache/helpdesk.conf /etc/apache2/sites-available/helpdesk.conf
RUN dos2unix /etc/apache2/sites-available/helpdesk.conf

RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bkp
COPY ./apache/apache2.conf /etc/apache2/apache2.conf
RUN dos2unix /etc/apache2/apache2.conf

RUN a2enmod ssl
RUN a2ensite default-ssl

RUN unlink /etc/apache2/sites-enabled/000-default.conf
RUN rm -fr /etc/apache2/sites-available/000-default.conf
RUN ln -s /etc/apache2/sites-available/helpdesk.conf /etc/apache2/sites-enabled/helpdesk.conf

COPY ./glpi/glpi-9.1.1.tgz ${VOL_DIR}/glpi-9.1.1.tgz
RUN tar xvzf ${VOL_DIR}/glpi-9.1.1.tgz -C ${VOL_DIR}/ \
    && rm -fr ${VOL_DIR}/glpi-9.1.1.tgz

VOLUME [ "/etc/helpdesk" ]

#SSH
EXPOSE 22
#Apache
EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/start-packages"]
