registry ?= docker.io

all: build

build:
	docker build -t zanox/mysql .

run:
	docker run --rm -it zanox/mysql bash

start: stop
	docker run -d --name mysql -p 3306:3306 zanox/mysql

exec:
	docker exec -it mysql bash

mysql:
	docker exec -it mysql mysql

stop:
	@docker rm -vf mysql ||:

pull:
	docker pull $(registry)/zanox/mysql

version ?= latest
push:
	docker tag zanox/mysql $(registry)/zanox/mysql:$(version)
	docker push $(registry)/zanox/mysql:$(version)

.PHONY: all build run start exec mysql stop pull push
