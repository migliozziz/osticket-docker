FROM banian/php

# Install packages
RUN apt-get update && \
    apt-get install -yf cron && \
    rm -rv /var/lib/apt

# Set upsteam repo
ENV GIT_REPO=https://github.com/osTicket/osTicket

# Scripts
COPY bin /bin
COPY conf/supervisord /etc/supervisor/conf.d/osticket.conf
COPY conf/msmtp /etc/msmtp.default

# Conf files
RUN touch /etc/msmtp /etc/osticket.secret.txt /etc/cron.d/osticket && \
    chown www-data:www-data /etc/msmtp /etc/osticket.secret.txt /etc/cron.d/osticket && \
    chown root:www-data /bin/vendor && chmod 770 /bin/vendor

# Deployment
RUN git clone ${GIT_REPO}
RUN rm /var/www/html/index*
RUN php /osTicket/manage.php deploy -v --setup /var/www/src/public/
RUN cp /var/www/src/public/include/ost-sampleconfig.php /var/www/src/public/include/ost-config.php

VOLUME /var/www
