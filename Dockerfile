FROM debian:jessie
MAINTAINER Yarek Tyshchenko <yarek.tyshchenko@affiliatewindow.com>

# Install bare MySQL server + pull down timezone tables
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends mysql-server-core-5.5 mysql-client-5.5 curl ca-certificates \
	&& apt-get download mysql-server-5.5 && dpkg-deb -R mysql-server-5.5_*.deb foo \
	&& cp foo/usr/bin/mysql_tzinfo_to_sql . && rm -r foo mysql-server-5.5_*.deb \
	&& apt-get clean && rm -r /var/lib/apt/lists/*

# Install S6
RUN curl -sL "https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz" | tar xz -C /

# Copy in s6 services config
COPY services.d /etc/services.d

RUN groupadd --system mysql \
    && useradd --system --gid mysql --home /var/lib/mysql mysql \
    && mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld \
    && touch /var/log/mysql_general.log && chown mysql:mysql /var/log/mysql_general.log \
    && mkdir -p /var/lib/mysql-files && chown mysql:mysql /var/lib/mysql-files \
    && mysql_install_db --user=mysql --skip-name-resolve --rpm

COPY start-mysql stop-mysql /bin/

# Wrap your MySQL commands with start-mysql and stop-mysql
# Anything inside will have access to MySQL server
RUN start-mysql && \
    echo "CREATE USER 'root'@'%'; GRANT ALL ON *.* TO 'root'@'%';" | mysql && \
    ./mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql mysql && \
    stop-mysql

EXPOSE 3306

# MySQLd is started with S6. See services.d/mysqld/run
CMD ["/init"]
