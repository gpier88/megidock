FROM webdevops/apache:ubuntu-18.04

LABEL maintainer="Eric Pfeiffer <computerfr33k@users.noreply.github.com>"

ARG DOCUMENT_ROOT=/var/www/
ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000
ARG PHP_UPSTREAM_TIMEOUT=300
ARG APACHE_INSTALL_HTTP2=false

ENV WEB_PHP_SOCKET=${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}
ENV WEB_DOCUMENT_ROOT=${DOCUMENT_ROOT}
ENV APACHE_HTTP2=${APACHE_INSTALL_HTTP2}
ENV WEB_PHP_TIMEOUT=${PHP_UPSTREAM_TIMEOUT}

ENV LOG_STDOUT=/var/log/apache2/access.log

ENV LOG_STDERR=/var/log/apache2/error.log

EXPOSE 80 443

WORKDIR /var/www/

COPY vhost.conf /etc/apache2/sites-enabled/vhost.conf

ADD ./auto_reload.sh /opt/auto_reload.sh
ADD ./check_ssl.sh /opt/check_ssl.sh
ADD ./generate_ssl.sh /opt/generate_ssl.sh

# Give execution rights on the cron scripts
RUN chmod 0755 /opt/auto_reload.sh
RUN chmod 0755 /opt/check_ssl.sh
RUN chmod 0755 /opt/generate_ssl.sh

#Install Cron
RUN docker-service-enable cron

# Add the cron job
RUN crontab -l | { cat; echo "* * * * * /bin/bash /opt/auto_reload.sh"; } | crontab -
RUN crontab -l | { cat; echo "0 */1 * * * /bin/bash /opt/auto_reload.sh --force"; } | crontab -
RUN crontab -l | { cat; echo "* * * * * /bin/bash /opt/check_ssl.sh"; } | crontab -
RUN crontab -l | { cat; echo "0 0,12 * * * certbot renew -q"; } | crontab -

ADD ./startup.sh /opt/startup.sh

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]

CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443

ARG APACHE_FOR_MAC_M1=false

RUN apt update -yqq && \
    apt install -yqq \
    python3 python3-venv libaugeas0

RUN python3 -m venv /opt/certbot/

RUN /opt/certbot/bin/pip install --upgrade pip && \
    /opt/certbot/bin/pip install certbot certbot-apache certbot-dns-ovh pyOpenSSL==23.1.1

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN if [ ${APACHE_FOR_MAC_M1} = true ]; then \
    # Change application source from deb.debian.org to aliyun source
    wget -O "/usr/local/bin/go-replace" "https://github.com/webdevops/goreplace/releases/download/1.1.2/gr-arm64-linux" && \
    chmod +x "/usr/local/bin/go-replace" && \
    "/usr/local/bin/go-replace" --version \
;fi
