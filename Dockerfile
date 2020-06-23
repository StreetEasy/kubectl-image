# syntax=docker/dockerfile:experimental

FROM golang:1.14.2 AS build

ARG KUBECTL_REPO=https://github.com/kubernetes/kubernetes.git
ARG KUBECTL_VERSION

RUN apt-get update && apt-get install -y rsync

RUN git clone ${KUBECTL_REPO} /go/src/k8s.io/kubernetes \
  && cd /go/src/k8s.io/kubernetes \
  && git checkout ${KUBECTL_VERSION} \
  ###################################################################
  #           temp fix until diff changes are merged
  && git remote add seth https://github.com/sethpollack/kubernetes \
  && git config --global user.email "sethpo@zillowgroup.com" \
  && git fetch seth diff-selectors \
  && git cherry-pick 75af2fca6125516dff42e9825ceea89367986f78
  ###################################################################
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
  jq \
  less \
  py-pip \
  python \
  python-dev \
  vim \
  && pip install awscli==${AWS_CLI_VERSION}

COPY --from=build /go/src/k8s.io/kubernetes/_output/bin/kubectl /usr/local/bin/kubectl

ENTRYPOINT ["/usr/local/bin/kubectl"]
