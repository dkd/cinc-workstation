FROM cincproject/workstation:25.13.7@sha256:999f5ce988661c32603755aada56d97177b093d001ed36eb0281409048c047be
LABEL maintainer="Ivan Golman <ivan.golman@dkd.de>, dkd Internet Service GmbH."

RUN chef gem install kitchen-docker rubocop overcommit

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    xz-utils

ARG scversion="stable"
RUN wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | \
    tar -xJv && cp "shellcheck-${scversion}/shellcheck" /usr/bin/

# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

# VirtualBox
RUN wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor -o /usr/share/keyrings/oracle-virtualbox.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" \
    > /etc/apt/sources.list.d/virtualbox.list

# HashiCorp (Vagrant)
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && \
    apt-get install -y \
    linux-headers-generic \
    docker-ce-cli \
    virtualbox-7.1 \
    vagrant \
    && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /var/log/*log \
    /var/log/apt/* \
    /var/lib/dpkg/*-old \
    /var/cache/debconf/*-old

RUN vagrant plugin install vagrant-cachier
