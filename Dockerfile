FROM alpine:3.7

RUN apk add --no-cache \
    curl \
    gcc \
    g++ \
    make

RUN mkdir -p /usr/src/dante && cd $_ && \
    curl -sL http://www.inet.no/dante/files/dante-1.4.2.tar.gz | tar -xzf - --strip 1 && \
    ac_cv_func_sched_setscheduler=no ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --disable-client \
        --without-libwrap \
        --without-bsdauth \
        --without-gssapi \
        --without-krb5 \
        --without-upnp \
        --without-pam && \
   make && make install

RUN mkdir -p /usr/bin/app
WORKDIR /usr/bin/app

COPY . /usr/bin/app/

ENV BIN_DIR /usr/bin/app/bin
ENV USERS_LIST /etc/users.list
ENV WORKERS 20

CMD sockd -N $WORKERS
