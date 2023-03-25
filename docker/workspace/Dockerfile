FROM php:8.1-fpm

WORKDIR /var/www/html

# apt
RUN apt-get update \
	&& apt-get install -y \
		mc \
		nano \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install mysqli

# config
COPY config/php.ini /usr/local/etc/php/php.ini

# user & ssh
## user
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN printf "[www]\n \
user = %s\n \
group = %s\n \
listen = 127.0.0.1:9000\n \
pm = dynamic\n \
pm.max_children = 5\n \
pm.start_servers = 2\n \
pm.min_spare_servers = 1\n \
pm.max_spare_servers = 3\n" ${PUID} ${PGID} > /usr/local/etc/php-fpm.d/www.conf

RUN groupadd -g $PUID workspace && \
    useradd workspace -u $PUID -g $PGID -m -s /bin/bash 

## ssh
RUN apt-get install openssh-server -y
RUN mkdir /var/run/sshd

RUN mkdir /root/.ssh \
	&& chmod 700 /root/.ssh
COPY ./ssh/root-ssh.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

RUN mkdir /home/workspace/.ssh \
	&& chmod 700 /home/workspace/.ssh
COPY ./ssh/workspace-ssh.pub /home/workspace/.ssh/authorized_keys
RUN chmod 600 /home/workspace/.ssh/authorized_keys \
	&& chown -R workspace:workspace /home/workspace

# timezone
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# cron
RUN apt-get install cron -y
COPY ./crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d
RUN crontab /etc/cron.d/workspace

# start.sh
RUN printf "/usr/sbin/cron\n \
php-fpm -D\n \
/usr/sbin/sshd -D\n" >> /start.sh
RUN chmod +x /start.sh

EXPOSE 22
CMD ["/start.sh"]