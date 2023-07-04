FROM --platform=linux/amd64 nvidia/cuda:12.2.0-devel-ubuntu20.04
# FROM --platform=linux/amd64 debian:bullseye-slim
  
# Install system dependencies
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    wget \
    git \
    screen \
    unzip \
    vim \
    procps \
    locales \
    python3-pip \
 && apt-get clean

# # Python unicode issues
# RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
# ENV LC_ALL=en_US.UTF-8
# ENV LANG=en_US.UTF-8
# ENV LANGUAGE=en_US.UTF-8

# Code server
# https://github.com/coder/code-server/releases
ARG VERSION=4.14.1
RUN mkdir -p ~/.local/lib ~/.local/bin
RUN curl -sfL https://github.com/cdr/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-amd64.tar.gz | tar -C ~/.local/lib -xz
RUN mv ~/.local/lib/code-server-$VERSION-linux-amd64 ~/.local/lib/code-server-$VERSION
RUN ln -s ~/.local/lib/code-server-$VERSION/bin/code-server /usr/local/bin/code-server

# Miniconda
RUN curl -sfL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/.local/miniconda
RUN ln -s ~/.local/miniconda/bin/conda /usr/local/bin/conda

WORKDIR /app
ENV SHELL /bin/bash
CMD /usr/local/bin/code-server --cert --bind-addr 0.0.0.0:8080 /app

# docker build -t codeserver-image_transformer .
# docker run --name codeserver-image_transformer -v $(pwd):/app -p 8080-8089:8080-8089 -it -d codeserver-image_transformer
# docker run --name codeserver-image_transformer --ipc host --gpus all -v $(pwd):/app -p 8080-8089:8080-8089 -it -d codeserver-image_transformer
# docker exec -it codeserver-image_transformer cat /root/.config/code-server/config.yaml

