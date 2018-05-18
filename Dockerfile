FROM debian:jessie
MAINTAINER Yarek Tyshchenko <yarek.tyshchenko@affiliatewindow.com>

RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
	key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	rm -r "$GNUPGHOME"; \
	apt-key list > /dev/null

RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-5.6" > /etc/apt/sources.list.d/mysql.list && \
    { \
        echo mysql-community-server mysql-community-server/root-pass password ''; \
        echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    } | debconf-set-selections && \
    apt-get update && env DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends \
    wget curl ca-certificates lsb-release mysql-community-server && \
	apt-get clean && rm -r /var/lib/apt/lists/*

# Install S6
RUN curl -sL "https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz" | tar xz -C /

# Copy in s6 services config
COPY services.d /etc/services.d

COPY start-mysql stop-mysql /bin/

# force MySQL client connection and both client and server default charsets to be UTF-8
RUN printf "[client]\ndefault-character-set=utf8\n[mysql]\ndefault-character-set=utf8\n[mysqld]\ncharacter-set-server=utf8" >> /etc/mysql/conf.d/charset.cnf


# Wrap your MySQL commands with start-mysql and stop-mysql
# Anything inside will have access to MySQL server
RUN start-mysql && \
    echo "status" | mysql && \
    echo "CREATE USER 'root'@'%'; GRANT ALL ON *.* TO 'root'@'%';" | mysql && \
    stop-mysql

EXPOSE 3306

# MySQLd is started with S6. See services.d/mysqld/run
CMD ["/init"]
