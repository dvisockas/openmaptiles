# FROM ubuntu:focal
FROM cruizba/ubuntu-dind

COPY . .


ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Vilnius"

RUN apt update \
 && apt -yqq install --no-install-recommends \
    git \
    curl \
    make \
    g++ \
    libtool \
    libyaml-dev \
    cmake \
    pkg-config \
    sudo \
    libssl-dev \
    ca-certificates \
    gnupg \
    gnupg2 \
    lsb-release \
  && apt -yqq install tzdata \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=""

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get remove -y docker docker-engine docker.io containerd runc
RUN apt-get install -yqq docker-ce docker-ce-cli containerd.io docker-compose-plugin
RUN ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose
RUN sudo chmod 666 /var/run/docker.sock

RUN docker-compose pull openmaptiles-tools generate-vectortiles postgres import-data
# RUN ./quickstart.sh
