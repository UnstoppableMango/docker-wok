FROM ubuntu:19.10 as build

RUN apt-get update && \
    apt-get install -y \
    gcc \
    make \
    autoconf \
    automake \
    git \
    python3-pip \
    python3-requests \
    python3-mock \
    gettext \
    pkgconf \
    xsltproc \
    python3-dev \
    pep8 \
    pyflakes \
    python3-yaml

RUN git clone https://github.com/kimchi-project/wok.git && \
    cd wok && \
    ./autogen.sh --system && \
    make && \
    make deb

FROM ubuntu:19.10
RUN apt-get update && \
    apt-get install -y \
        systemd \
        logrotate \
        python3-psutil \
        python3-ldap \
        python3-lxml \
        python3-websockify \
        python3-jsonschema \
        openssl \
        nginx \
        python3-cherrypy3 \
        python3-cheetah \
        python3-pam \
        python-m2crypto \
        gettext \
        python3-openssl

COPY --from=build /wok/wok*ubuntu*.deb .
RUN dpkg -i wok*.deb

ENTRYPOINT [/usr/bin/wokd]
