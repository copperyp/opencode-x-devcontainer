FROM nvidia/cuda:12.9.1-devel-ubuntu22.04

ARG HTTPS_PROXY
ARG HTTP_PROXY

ENV https_proxy=${HTTPS_PROXY}
ENV http_proxy=${HTTP_PROXY}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER developer
WORKDIR /home/developer

RUN chown -R developer:developer /home/developer

RUN curl -fsSL https://opencode.ai/install | bash

CMD ["/bin/bash"]
