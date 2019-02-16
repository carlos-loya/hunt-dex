# hunt-dex
[![Build Status](https://travis-ci.org/carlos-loya/hunt-dex.svg?branch=master)](https://travis-ci.org/carlos-loya/hunt-dex)

A website for Hunters who want to keep track of their captured pets.


## Development

### Installation

    cd $GOPATH/src/github.com/carlos-loya/
    git clone https://github.com/carlos-loya/hunt-dex.git

### Feature Branching
To ensure the master repository is as stable as can be, don't make changes directly in the master branch. Instead create a new feature branch
that you can merge into the master branch through a Pull Request.

To create a new branch:

    git checkout -b cool-new-feature-branch

### Docker


#### Docker-compose

##### Up

    loya@gödel hunt-dex (decoupling) λ docker-compose up
    Creating network "hunt-dex_default" with the default driver
    Creating hunt-dex_app_1 ... done
    Attaching to hunt-dex_app_1
    app_1  | [GIN-debug] [WARNING] Now Gin requires Go 1.6 or later and Go 1.7 will be required soon.
    app_1  |

    app_1  | [GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.
    app_1  |
    app_1  | [GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
    app_1  |  - using env:  export GIN_MODE=release
    app_1  |  - using code: gin.SetMode(gin.ReleaseMode)
    app_1  |
    app_1  | [GIN-debug] GET    /ping                     --> main.setupRouter.func1 (3 handlers)
    app_1  | [GIN-debug] GET    /user/:name               --> main.setupRouter.func2 (3 handlers)
    app_1  | [GIN-debug] POST   /admin                    --> main.setupRouter.func3 (4 handlers)
    app_1  | [GIN-debug] Listening and serving HTTP on :8080

##### Down

`docker-compose down` is a command you need to know to test the latest changes of your dockerfile

    loya@gödel hunt-dex (decoupling) λ docker-compose down
    Stopping hunt-dex_app_1 ... done
    Removing hunt-dex_app_1 ... done
    Removing network hunt-dex_default

### Travis CI

The link to the build for master branch is here: https://travis-ci.org/carlos-loya/hunt-dex


### Makefile

#### Dependencies

Will fetch all dependencies for this project.

    loya@gödel hunt-dex (decoupling) λ make deps
    set -ex \
                    && go get -u github.com/golang/dep/cmd/dep \
                    && dep ensure -vendor-only
    + go get -u github.com/golang/dep/cmd/dep
    + dep ensure -vendor-only -v
    (1/9) Wrote gopkg.in/yaml.v2@a5b47d31c556af34a302ce5d659e6fea44d90de0
    (2/9) Wrote gopkg.in/go-playground/validator.v8@v8.18.1
    (3/9) Wrote github.com/gin-gonic/gin@v1.3.0
    (4/9) Wrote github.com/gin-contrib/sse@22d885f9ecc78bf4ee5d72b937e4bbcdc58e8cae
    (5/9) Wrote github.com/ugorji/go@c88ee250d0221a57af388746f5cf03768c21d6e2
    (6/9) Wrote github.com/mattn/go-isatty@57fdcb988a5c543893cc61bce354a6e24ab70022
    (7/9) Wrote github.com/golang/protobuf@5a0f697c9ed9d68fef0116532c6e05cfeae00e55
    (8/9) Wrote github.com/json-iterator/go@1.0.0
    (9/9) Wrote golang.org/x/sys@master

#### Testing

    loya@gödel hunt-dex (decoupling) λ make test
    set -ex \
        && go test -v ./...
    + go test -v ./...
    ?       github.com/carlos-loya/hunt-dex [no test files]

Need to write some tests!

#### Build

    loya@gödel hunt-dex (decoupling) λ make build
    set -ex \
        && go build -o bin/hunt-dex -v
    + go build -o bin/hunt-dex -v

#### Clean

    loya@gödel hunt-dex (decoupling) λ make clean
    set -ex \
            && go clean \
            && rm -f "bin/hunt-dex" \
            && rm -f "bin/hunt-dex_unix" \
            && docker image prune -f
    + go clean
    + rm -f bin/hunt-dex
    + rm -f bin/hunt-dex_unix
    + docker image prune -f
    Total reclaimed space: 0B

#### Run

The Makefile's run method will first do a `make docker` then run that new docker image with a `docker-compose up`

    loya@gödel hunt-dex (decoupling) λ make run
    set -ex \

            && docker-compose up
    + docker-compose up
    Creating network "hunt-dex_default" with the default driver
    Creating hunt-dex_app_1 ... done
    Attaching to hunt-dex_app_1
    app_1  | [GIN-debug] [WARNING] Now Gin requires Go 1.6 or later and Go 1.7 will be required soon.
    app_1  |
    app_1  | [GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.
    app_1  |
    app_1  | [GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
    app_1  |  - using env:  export GIN_MODE=release
    app_1  |  - using code: gin.SetMode(gin.ReleaseMode)
    app_1  |
    app_1  | [GIN-debug] GET    /ping                     --> main.setupRouter.func1 (3 handlers)
    app_1  | [GIN-debug] GET    /user/:name               --> main.setupRouter.func2 (3 handlers)
    app_1  | [GIN-debug] POST   /admin                    --> main.setupRouter.func3 (4 handlers)
    app_1  | [GIN-debug] Listening and serving HTTP on :8080

#### Docker

    loya@gödel hunt-dex (decoupling) λ make docker
    set -ex \
                    && docker build --no-cache -t "hunt-dex:$(git log -1 --pretty=%H)" . \
                    && docker tag "hunt-dex:$(git log -1 --pretty=%H)" hunt-dex:latest \
                    && docker image prune -f
    ++ git log -1 --pretty=%H
    + docker build --no-cache -t hunt-dex:dadbc54f0283e34e5f813eec39d562ea91ffd95c .
    Sending build context to Docker daemon  14.39MB
    Step 1/10 : FROM golang:alpine AS build
     ---> cb1c8647572c
    Step 2/10 : RUN set -ex   && apk add --no-cache git   && go get github.com/golang/dep/cmd/dep
     ---> Running in 49f36a853895
    + apk add --no-cache git
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/main/x86_64/APKINDEX.tar.gz
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/community/x86_64/APKINDEX.tar.gz
    (1/6) Installing nghttp2-libs (1.35.1-r0)
    (2/6) Installing libssh2 (1.8.0-r4)
    (3/6) Installing libcurl (7.63.0-r0)
    (4/6) Installing expat (2.2.6-r0)
    (5/6) Installing pcre2 (10.32-r1)
    (6/6) Installing git (2.20.1-r0)
    Executing busybox-1.29.3-r10.trigger
    OK: 20 MiB in 21 packages
    + go get github.com/golang/dep/cmd/dep

    Removing intermediate container 49f36a853895
     ---> 84093a433676
    Step 3/10 : COPY . /go/src/hunt-dex/
     ---> 3932d41a2e79
    Step 4/10 : WORKDIR /go/src/hunt-dex/
     ---> Running in 5ac4512c0a48
    Removing intermediate container 5ac4512c0a48
     ---> 748699aee37b
    Step 5/10 : RUN set -ex   && dep ensure -vendor-only   && go build -o /bin/hunt-dex
     ---> Running in 529f5fea5eb6
    + dep ensure -vendor-only
    + go build -o /bin/hunt-dex
    Removing intermediate container 529f5fea5eb6
     ---> c6f962154d3c
    Step 6/10 : FROM alpine:latest
     ---> caf27325b298
    Step 7/10 : COPY --from=build /bin/hunt-dex /bin/hunt-dex
     ---> 6623aac8db00
    Step 8/10 : RUN set -ex   && apk add --update ca-certificates
     ---> Running in cd6eb9cc245b
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/main/x86_64/APKINDEX.tar.gz
    + apk add --update ca-certificates
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/community/x86_64/APKINDEX.tar.gz
    (1/1) Installing ca-certificates (20190108-r0)
    Executing busybox-1.29.3-r10.trigger
    Executing ca-certificates-20190108-r0.trigger
    OK: 6 MiB in 15 packages
    Removing intermediate container cd6eb9cc245b
     ---> 771958c4f796
    Step 9/10 : ENTRYPOINT ["/bin/hunt-dex"]
     ---> Running in a4fc5dd2858e

    Removing intermediate container a4fc5dd2858e
     ---> cb382c528cb4
    Step 10/10 : EXPOSE 8080
     ---> Running in 0d273ddde9a2
    Removing intermediate container 0d273ddde9a2
     ---> e79b6a7bd968
    Successfully built e79b6a7bd968
    Successfully tagged hunt-dex:dadbc54f0283e34e5f813eec39d562ea91ffd95c
    ++ git log -1 --pretty=%H
    + docker tag hunt-dex:dadbc54f0283e34e5f813eec39d562ea91ffd95c hunt-dex:latest
    + docker image prune -f
    Deleted Images:
    deleted: sha256:c6f962154d3c894383e62255f0c8565da9c4b2dff77aab9df5a7b7a4e6e09c5f
    deleted: sha256:78bf0dcfacec0dfbb2610fead1356fa1ab22b5bbd80e9956a0d0a9afecb39cc0
    deleted: sha256:748699aee37b230a8402545c8d21f7b004e5aa6d3c5b85a285f496caceb6c3ab
    deleted: sha256:3932d41a2e797e3b2a825df6eaafea5f3b06e7a7c97c90aeeebe8e0e4e504368
    deleted: sha256:929a915c82ce57ceab9eba4e58e0b5172f006a8d0363d74fdc217176d20f8eae
    deleted: sha256:84093a4336760a6249f3bb675b774ce4d361efddbcb322ba7b98bc87d0a63fbb
    deleted: sha256:c30c3e07599aaec9533764deecceaae84bd37c0573a3c455831d3894a628b4e5

    Total reclaimed space: 157.5MB


#### Push

This command will push your most recently built hunt-dex image to the repo on docker hub.
For this step, you'll need an account on docker hub and need to be invited to the repository.
Ask an admin for an invitation.


    loya@gödel hunt-dex (decoupling) λ make push
    set -ex \
                    && docker login \
                    && docker tag hunt-dex:latest carlosloya/hunt-dex:latest \
                    && docker push carlosloya/hunt-dex:latest

    + docker login
    Authenticating with existing credentials...
    Login Succeeded
    + docker tag hunt-dex:latest carlosloya/hunt-dex:latest
    + docker push carlosloya/hunt-dex:latest
    The push refers to repository [docker.io/carlosloya/hunt-dex]
    db1bf217ae95: Pushed
    6e36cbfa270b: Pushed
    503e53e365f3: Layer already exists
    latest: digest: sha256:360f6e951387673d17344a38d3dbb6e41c0fffcc4d756278e71644af89a2e2fe size: 950
