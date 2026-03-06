FROM ubuntu:22.04

ARG HTTPS_PROXY
ARG HTTP_PROXY

ENV https_proxy=${HTTPS_PROXY}
ENV http_proxy=${HTTP_PROXY}

ENV DEBIAN_FRONTEND=noninteractive
ENV RUSTUP_HOME=/home/developer/.rustup
ENV CARGO_HOME=/home/developer/.cargo
ENV PATH=/home/developer/.cargo/bin:$PATH

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

RUN useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R developer:developer /home/developer

USER developer
WORKDIR /home/developer

RUN rm -rf /home/developer/.cache

RUN curl -fsSL https://opencode.ai/install | bash

CMD ["/bin/bash"]
