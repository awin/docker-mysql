Docker MySQL Database
=====================

Alternative Docker MySQL image optimised for fast startup time

This image is intended to be extended by your own Dockerfile, with custom init.sql and build steps

Extending the image
===================

In your project add a Dockerfile for your fixtures database:

```
FROM zanox/docker-mysql

COPY schema.sql /

RUN start-mysql && \
    mysql < schema.sql && \
    echo "status" | mysql && \
    stop-mysql
```

Also provide a Makefile so the database can be built simply (You can copy this Makefile to use as template)

Then simply provide a static schema SQL file that can run your project, start and stop the database as much
as you like, It should always take fractions of a second.
