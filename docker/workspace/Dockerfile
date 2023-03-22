FROM php:8.1-fpm

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install mysqli

EXPOSE 22

RUN apt-get install openssh-server -y
RUN mkdir /var/run/sshd

RUN mkdir /root/.ssh \
	&& chmod 700 /root/.ssh
COPY ./ssh/root-ssh.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupadd -g ${PGID} workspace && \
    useradd workspace -u ${PUID} -g ${PGID} -m -s /bin/bash 

RUN mkdir /home/workspace/.ssh \
	&& chmod 700 /home/workspace/.ssh
COPY ./ssh/workspace-ssh.pub /home/workspace/.ssh/authorized_keys
RUN chmod 600 /home/workspace/.ssh/authorized_keys \
	&& chown -R workspace:workspace /home/workspace
	
RUN printf "php-fpm -D\n/usr/sbin/sshd -D" >> /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]