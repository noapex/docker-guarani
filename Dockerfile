FROM siutoba/docker-web:V1.2
MAINTAINER ablanco@siu.edu.ar

COPY gestion.sh /entrypoint.d/
COPY autogestion.sh /entrypoint.d/
COPY preinscripcion.sh /entrypoint.d/
RUN mkdir /var/local/autogestion_conf/
COPY var/autogestion/* /var/local/autogestion_conf/
RUN mkdir /var/local/preinscripcion_conf/
COPY var/preinscripcion/* /var/local/preinscripcion_conf/
RUN mkdir /var/local/gestion_conf/
COPY var/gestion/entorno_toba_2.6.sh /var/local/gestion_conf/entorno_toba_2.6.sh
RUN apt-get update -y && apt-get install postgresql-client-9.4 -y && apt-get install fop -y && apt-get install libfreetype6 libfreetype6-dev -y
RUN pecl install 'xdebug'
COPY conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN echo 'memory_limit = 1024M' >> /usr/local/etc/php/php.ini
RUN echo 'default_charset = ""' >> /usr/local/etc/php/php.ini
RUN echo 'pg:5432:*:postgres:postgres' > /root/.pgpass && chmod 700 /root/.pgpass
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2/  --enable-gd-native-ttf && docker-php-ext-install gd
RUN docker-php-ext-install exif

ENV JASPER_HOST jasper
ENV JASPER_PORT 8081

RUN chmod +x /entrypoint.d/*.sh

