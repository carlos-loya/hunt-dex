FROM golang:alpine AS build

RUN set -ex \
  && apk add --no-cache git \
  && go get github.com/golang/dep/cmd/dep

COPY . /go/src/github.com/carlos-loya/hunt-dex/
WORKDIR /go/src/github.com/carlos-loya/hunt-dex/

RUN set -ex \
  && dep ensure -vendor-only -v \
  && pwd \
  && go build -o /bin/hunt-dex

FROM alpine:latest
COPY --from=build /bin/hunt-dex /bin/hunt-dex

RUN set -ex \
  && apk add --update ca-certificates

ENTRYPOINT ["/bin/hunt-dex"]

EXPOSE 8080
