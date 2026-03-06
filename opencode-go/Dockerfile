FROM ubuntu:22.04

ARG HTTPS_PROXY
ARG HTTP_PROXY

ENV https_proxy=${HTTPS_PROXY}
ENV http_proxy=${HTTP_PROXY}

ENV DEBIAN_FRONTEND=noninteractive

ENV GO_VERSION=1.24.1
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

RUN mkdir -p $GOPATH/src && \
    useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R developer:developer /home/developer

RUN rm -rf /home/developer/.cache

WORKDIR /home/developer
USER developer
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && \
    echo 'export GOPATH=$GOPATH' >> ~/.bashrc && \
    echo 'export PATH=$GOPATH/bin:$PATH' >> ~/.bashrc
RUN curl -fsSL https://opencode.ai/install | bash
CMD ["/bin/bash"]

