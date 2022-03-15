FROM ubuntu:20.04

ENV VERSION=v4.22.1 \
    BINARY=yq_linux_amd64

# Install and preparare workdir
RUN apt-get update && apt-get install -y wget \
    && wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |tar xz \
    && mv ${BINARY} /usr/bin/yq \
    && mkdir -p /workdir

WORKDIR /workdir

COPY ./cloudformation-patcher /usr/local/bin

RUN chmod u+x /usr/local/bin/cloudformation-patcher

ENTRYPOINT [ "cloudformation-patcher" ]