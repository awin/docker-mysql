Docker MySQL Database
=====================

Alternative Docker MySQL image optimised for fast startup time

This image is intended to be extended by your own Dockerfile, with custom init.sql and build steps

FROM zanox/docker-mysql
=======================

```
FROM zanox/docker-mysql

COPY schema.sql /

RUN /start.sh && \
    mysql < schema.sql && \
    /kill.sh

```
