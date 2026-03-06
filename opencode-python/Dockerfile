FROM ubuntu:22.04

ARG HTTPS_PROXY
ARG HTTP_PROXY

ENV https_proxy=${HTTPS_PROXY}
ENV http_proxy=${HTTP_PROXY}

ENV DEBIAN_FRONTEND=noninteractive

ENV PYTHON_VERSION=3.12
ENV PIP_CACHE_DIR=/home/developer/.cache/pip

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    software-properties-common \
    curl sudo bash bash-completion \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python${PYTHON_VERSION}-venv && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

RUN useradd -m -s /bin/bash developer && \
    usermod -aG sudo developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R developer:developer /home/developer

RUN rm -rf /home/developer/.cache

WORKDIR /home/developer

USER developer
RUN curl -fsSL https://opencode.ai/install | bash
CMD ["/bin/bash"]
