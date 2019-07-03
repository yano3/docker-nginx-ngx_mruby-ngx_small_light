FROM yano3/nginx-ngx_mruby:1.17.1-ngx_mruby2.1.4

ENV NGINX_VERSION=1.17.1
ENV NGX_SMALL_LIGHT_VERSION=0.9.2

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    git \
    curl \
    build-essential \
    ca-certificates \
    libmagickwand-dev \
 \
 && apt-mark manual libmagickwand-6.q16-3 \
 && cd /usr/local/src \
 && git clone --branch v$NGX_SMALL_LIGHT_VERSION --depth 1 https://github.com/cubicdaiya/ngx_small_light.git \
 && curl -s -OL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && tar -xf nginx-$NGINX_VERSION.tar.gz \
 \
 && cd /usr/local/src/ngx_small_light \
 && ./setup \
 \
 && cd /usr/local/src/nginx-$NGINX_VERSION \
 && ./configure \
    --with-compat \
    --add-dynamic-module=../ngx_small_light \
 && make modules \
 && cp -p ./objs/*.so /etc/nginx/modules/ \
 \
 && cd / \
 && rm -rf /usr/local/src/* \
 && apt-get remove --purge -y \
 && apt-get remove --purge --auto-remove -y \
    git \
    curl \
    build-essential \
    ca-certificates \
    libmagickwand-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
