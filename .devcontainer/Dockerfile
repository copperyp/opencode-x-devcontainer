FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ARG HTTPS_PROXY
ARG HTTP_PROXY

ENV https_proxy=${HTTPS_PROXY}
ENV http_proxy=${HTTP_PROXY}

RUN sed -i 's|http|https|g' /etc/apt/sources.list

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        build-essential \
        cmake \
        gdb \
        git \
        curl \
        wget \
        vim \
        ripgrep \
        fd-find \
        unzip \
        gzip \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*



# Install Docker CLI 26
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli=5:28* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV OPENCODE_CONFIG_DIR=/home/vscode/.config/opencode

USER vscode
RUN curl -fsSL https://opencode.ai/install | bash

