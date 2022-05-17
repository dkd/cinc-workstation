This image based on opensource [CINC Workstation](https://cinc.sh/start/workstation/) provides the complete test suite for running regression tests on CHEF cookbooks. One may use it in [GitLab](https://docs.gitlab.com/ee/ci/pipelines/) CI-Pipeline. 

Following tools additionally to [official image](https://hub.docker.com/r/cincproject/workstation) are included:
* `kitchen-docker` 
* `rubocop` 
* `overcommit`
* `shellcheck`
* `docker-cli`

### Dockerfile
```
FROM cincproject/workstation:21.10.640
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
  linux-headers-5.4.0-90-generic \
  docker-ce-cli \
  virtualbox-6.1 \
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
```

## Contributing

* Fork the repo.
* Create a branch from the develop branch and name it 'feature/name-of-feature': `git checkout -b feature/my-new-feature` (We follow [this branching model] (http://nvie.com/posts/a-successful-git-branching-model/))
* Make sure you test your new feature.
* Commit your changes together with specs for them: `git commit -am 'Add some feature'`
* Push your changes to your feature branch.
* Submit a pull request to the **develop** branch. Describe your feature in the pull request. Make sure you commit the specs.
* A pull request does not necessarily need to represent the final, finished feature. Feel free to treat it as a base for discussion.
