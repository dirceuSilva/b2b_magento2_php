FROM php:7.0-fpm

RUN apt-get update  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  gd \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  soap \
  xsl \
  zip \
  bcmath

RUN pecl install xdebug-stable

RUN curl -sS https://getcomposer.org/installer | \
    php -- \
      --install-dir=/usr/local/bin \
      --filename=composer \
      --version=1.5.6

RUN mkdir -p /usr/share/copec/debfiles \
    && mkdir -p /var/log/copec/magento \
    && mkdir -p /opt/copec/storage \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update && apt-get install -y wget apt-transport-https lsb-release ca-certificates fakeroot vim less \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && echo "deb file:/usr/share/copec/debfiles/ ./" > /etc/apt/sources.list.d/copec.list

RUN echo "php_admin_flag[log_errors] = on" > /usr/local/etc/php-fpm.d/zz-log.conf && \
    echo "php_flag[display_errors] = off" >> /usr/local/etc/php-fpm.d/zz-log.conf

RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.default_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_handler = dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_connect_back = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_host = 172.17.0.1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.profiler_output_dir=\"/tmp\"" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "memory_limit=-1" > /usr/local/etc/php/php.ini

RUN echo "alias update-deb='cd /usr/share/copec/debfiles/ && cp -R /tmp/project/target/*.deb ./ && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz && apt-get update && cd -'" >> /root/.bashrc \
    && echo "alias build-copec='cd /tmp/project && ./build-copec-b2b-magento.sh 0.0.1 && cd -'" >> /root/.bashrc

WORKDIR /src

VOLUME /src
VOLUME /root/.composer

CMD ["/usr/local/sbin/php-fpm"]