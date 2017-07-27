repo ?= docker.io

all: build

build:
	docker build -t zanox/mysql .

run:
	docker run --rm -it zanox/mysql bash

start: stop
	docker run -d --name mysql -p 3306:3306 zanox/mysql

stop:
	@docker rm -vf mysql ||:

pull:
	docker pull $(repo)/zanox/mysql

push:
	docker tag -f zanox/mysql $(repo)/zanox/mysql
	docker push $(repo)/zanox/mysql

.PHONY: all build run start stop pull push
