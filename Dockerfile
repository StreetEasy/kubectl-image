# syntax=docker/dockerfile:experimental

FROM golang:1.14.2 AS build

ARG KUBECTL_REPO
ARG KUBECTL_COMMIT

RUN apt-get update && apt-get install -y rsync

RUN git clone ${KUBECTL_REPO} /go/src/k8s.io/kubernetes \
  && cd /go/src/k8s.io/kubernetes \
  && git checkout ${KUBECTL_COMMIT}

WORKDIR /go/src/k8s.io/kubernetes

RUN make kubectl

FROM alpine:3.6

ARG AWS_CLI_VERSION

RUN apk --no-cache update && \
  apk --no-cache add \
  build-base \
  ca-certificates \
  curl \
  groff \
  less \
  py-pip \
  python \
  python-dev \
  vim \
  && pip install awscli==${AWS_CLI_VERSION}

COPY --from=build /go/src/k8s.io/kubernetes/_output/bin/kubectl /usr/local/bin/kubectl

ENTRYPOINT ["/usr/local/bin/kubectl"]
