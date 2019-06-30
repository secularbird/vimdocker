FROM ubuntu:18.04

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && rm -Rf /var/lib/apt/lists/*

RUN apt update && apt dist-upgrade -y && apt install -y vim \
    gcc \
    g++ \
    clang \
    wget \
    python3 \
    curl \
    git \
    xfonts-utils \
    fontconfig \
    xclip \
    cmake \
    gettext \
    lua5.3 \
    unzip \
    python-pip \
    python3-pip \
    nodejs \
    cscope \
    && rm -Rf /var/lib/apt/lists/*


# install golang
RUN add-apt-repository ppa:gophers/archive
RUN apt-get update && apt-get install golang-1.12-go

ENV HOME /home/spacevim

# install spacevim
RUN groupdel users                                              \
  && groupadd -r spacevim                                       \
  && useradd --create-home --home-dir $HOME                     \
             -r -g spacevim                                     \
             spacevim

USER spacevim

WORKDIR $HOME
ENV PATH "$HOME/.local/bin:${PATH}"

RUN curl -sLf https://spacevim.org/install.sh | bash
ONBUILD COPY init.toml $HOME/.SpaceVim.d/

RUN vim +SPInstall +qall

ENTRYPOINT ["vim"]
