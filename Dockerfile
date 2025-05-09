FROM cincproject/workstation:24.8.1068
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

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

RUN wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

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
