# .PHONY: build certs run

# certs:
# 	sh ./generate.sh

# build:
# 	docker build -t nginx-certs .

# run:
# 	docker run -it --rm -d -p 8000:8000 --name custom-nginx nginx-certs

# .DEFAULT_GOAL := build

.PHONY: certs run build fake-certs test

build: certs run

# certs:
# 	docker run --rm -e FAKETIME=-0.99d --name fake-time faketime-image -v ./nginx/certs:/app/certs

run:
	docker-compose up --build 

certs:
	docker-compose -f docker-compose-fake-time.yml up --build

.DEFAULT_GOAL := build