FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/phpearth/docker-php.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="PHP.earth" \
      org.label-schema.name="docker-php" \
      org.label-schema.description="Docker For PHP Developers - Docker image with PHP 7.4, Nginx, and Alpine" \
      org.label-schema.url="https://github.com/phpearth/docker-php"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.4

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        nginx \
        nginx-mod-http-headers-more \
        php7.4 \
        php7.4-phar \
        php7.4-bcmath \
        php7.4-calendar \
        php7.4-mbstring \
        php7.4-exif \
        php7.4-ftp \
        php7.4-openssl \
        php7.4-zip \
        php7.4-sysvsem \
        php7.4-sysvshm \
        php7.4-sysvmsg \
        php7.4-shmop \
        php7.4-sockets \
        php7.4-zlib \
        php7.4-bz2 \
        php7.4-curl \
        php7.4-simplexml \
        php7.4-xml \
        php7.4-opcache \
        php7.4-dom \
        php7.4-xmlreader \
        php7.4-xmlwriter \
        php7.4-tokenizer \
        php7.4-ctype \
        php7.4-session \
        php7.4-fileinfo \
        php7.4-iconv \
        php7.4-json \
        php7.4-posix \
        php7.4-fpm \
        php7.4-openssl \
        php7.4-gd \
        php7.4-mysqli \
        php7.4-sockets \
        curl \
        ca-certificates \
        runit \
"

# PHP.earth Alpine repository for better developer experience
ADD https://repos.php.earth/alpine/phpearth.rsa.pub /etc/apk/keys/phpearth.rsa.pub

RUN set -x \
    && echo "https://repos.php.earth/alpine/v3.9" >> /etc/apk/repositories \
    && apk add --no-cache $DEPS \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY tags/nginx /

EXPOSE 80

CMD ["/sbin/runit-wrapper"]
