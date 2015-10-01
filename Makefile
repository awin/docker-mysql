repo ?= docker.io

all: build

build:
	docker build -t zanox/docker-mysql .

run:
	docker run --name docker-mysql -d -p 3306:3306 zanox/docker-mysql

stop:
	@docker rm -vf docker-mysql ||:

push:
	docker tag -f zanox/docker-mysql $(repo)/zanox/docker-mysql
	docker push $(repo)/zanox/docker-mysql

.PHONY: all build run stop push
