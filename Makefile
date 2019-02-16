GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=hunt-dex
BINARY_UNIX=$(BINARY_NAME)_unix
DOCKER_REPO=carlosloya
TAG=$$(git log -1 --pretty=%H)
IMG="$(BINARY_NAME):$(TAG)"
LATEST=$(BINARY_NAME):latest

all: clean test build docker

build:
	set -ex \
	&& $(GOBUILD) -o bin/${BINARY_NAME} -v
docker:
	set -ex \
		&& docker build --no-cache -t ${IMG} . \
		&& docker tag ${IMG} ${LATEST} \
		&& docker image prune -f
test:
	set -ex \
	&& $(GOTEST) -v ./...
clean:
	set -ex \
	&& $(GOCLEAN) \
	&& rm -f "bin/${BINARY_NAME}" \
	&& rm -f "bin/${BINARY_UNIX}" \
	&& docker image prune -f
run: docker
	set -ex \
	&& docker-compose up
deps:
	set -ex \
		&& $(GOGET) -u github.com/golang/dep/cmd/dep \
		&& dep ensure -vendor-only -v
push:
	set -ex \
		&& docker login \
		&& docker tag ${LATEST} ${DOCKER_REPO}/${LATEST} \
		&& docker push ${DOCKER_REPO}/${LATEST}

build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o bin/$(BINARY_UNIX) -v
