FROM nginx:latest

# config
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/conf.d /etc/nginx/conf.d/
COPY sites-available/ /etc/nginx/sites-available
RUN rm /etc/nginx/conf.d/default.conf

# timezone
ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# logrotate & cron
RUN apt update \
    && apt install logrotate cron -y
COPY logrotate/nginx /etc/logrotate.d/
RUN chmod -R 644 /etc/logrotate.d

RUN printf "0 0 * * * root /usr/sbin/logrotate -f /etc/logrotate.conf >> /dev/null 2>&1\n" > /etc/cron.d/logrotate
RUN chmod -R 644 /etc/cron.d
RUN crontab /etc/cron.d/logrotate

# user
ARG PUID=1000
ARG PGID=1000

RUN groupadd -g $PUID workspace && \
    useradd workspace -u $PUID -g $PGID -m -s /bin/bash 

# start.sh
RUN printf "/usr/sbin/cron\n \
nginx -g \"daemon off;\"\n" >> /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]