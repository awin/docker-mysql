registry ?= docker.io

all: build

build:
	docker build -t zanox/mysql8 .

run:
	docker run --rm -it zanox/mysql8 bash

start: stop
	docker run -d --name mysql -p 3306:3306 zanox/mysql8

exec:
	docker exec -it mysql bash

mysql:
	docker exec -it mysql mysql

stop:
	@docker rm -vf mysql ||:

pull:
	docker pull $(registry)/zanox/mysql8

version ?= latest
push:
	docker tag zanox/mysql8 $(registry)/zanox/mysql8:$(version)
	docker push $(registry)/zanox/mysql8:$(version)

.PHONY: all build run start exec mysql stop pull push
