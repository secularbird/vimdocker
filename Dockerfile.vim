FROM ubuntu:16.04

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && rm -Rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
    gcc \
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
    && rm -Rf /var/lib/apt/lists/*


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

RUN git clone https://github.com/vim/vim.git
RUN cd vim && ./configure  && make -j4

RUN curl -sLf https://spacevim.org/install.sh | bash
ONBUILD COPY init.toml $HOME/.SpaceVim.d/

RUN vim +SPInstall +qall

ENTRYPOINT ["vim"]
