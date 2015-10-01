all: build

build:
	docker build -t docker-mysql .

run:
	docker run --rm -it docker-mysql bash

.PHONY: all build run
