MySQL Base Image
================

[![](https://badge.imagelayers.io/zanox/mysql:latest.svg)](https://imagelayers.io/?images=zanox/mysql:latest 'Zanox MySQL Image Layers')

This is a MySQL Database image tuned for fast start up times, designed to be
extended for purposes of providing fixtures.

The Official MySQL Image, while Ok to use as a normal database, does too many
things on startup. Instead we install the database directory and preload the
schema during build and commit the result to disk.

The result is an image that, once built, can be stopped and started in a
fraction of a second, making it suitable to use as part of your integration
test suite.

How to use this image
---------------------

Extend this image within your `Dockerfile` using the FROM directive. Do all the
setup work needed during the build. You can use any tools you want as long as
you wrap the commands in `start-mysql` and `stop-mysql`. The changes to the
database directory will then be commited as a file system layer by docker.

The reasoning behind using the start and stop commands is that it allows you
to split up your setup procedure and leverage docker's caching mechanism,
rather than executing all the steps as one large shell script.

The disadvantage is of course COW duplication of any touched tables for each RUN
directive.

Example Dockerfile:

```
COPY schema.sql /
RUN start-mysql && \
    mysql < schema.sql && \
    echo "status" | mysql && \
    stop-mysql
```


Notes on the Makefile
=====================

You can try this project out by running `make build run` and connecting to
default mysql port on your dockerhost. The Makefile makes trying the project
out consistent and simple. I would encourage you to use it as a template for
your own project.

License
=======

```
Copyright (c) 2015, Digital Window Limited
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
