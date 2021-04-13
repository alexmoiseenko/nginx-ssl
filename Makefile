.PHONY: certs run build fake-certs test

build: certs run

run:
	docker-compose up --build 

certs:
	docker-compose -f docker-compose-fake-time.yml up --build

.DEFAULT_GOAL := build