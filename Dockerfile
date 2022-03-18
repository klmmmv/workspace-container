FROM ubuntu:latest
ARG PW=notpassword
RUN mkdir /home/valentin && \
    echo "valentin:x:1337:1337:valentin:/home/valentin:/usr//bin/bash" >> /etc/passwd && \
    echo "valentin:x:1337" >> /etc/group && \
    echo "valentin:!:19069:0:99999:7:::" >> /etc/shadow

RUN apt-get update && apt-get install -y \
    unzip \
    git \
    bat \
    direnv \
    curl \
    vim \
    silversearcher-ag \
    fd-find \
    fzf

RUN curl -s "https://api.github.com/repos/ogham/exa/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+' > version.tmp && \
    curl -Lo exa.zip "https://github.com/ogham/exa/releases/latest/download/exa-linux-x86_64-v$(cat version.tmp).zip" && \
    unzip -q exa.zip bin/exa -d /usr/local

RUN sh -c "$(curl -sS https://starship.rs/install.sh)" -- --yes

ENV HOME=/home/valentin

RUN mkdir $HOME/dotfiles && \
    git clone --bare https://github.com/klmmmv/dotfiles $HOME/dotfiles

RUN printf '#!/bin/bash\n' > /usr/bin/dotfiles && \
    printf 'git --git-dir=$HOME/dotfiles --work-tree=$HOME "$@"' >> /usr/bin/dotfiles && \
    chmod +x /usr/bin/dotfiles

WORKDIR "/home/valentin"
RUN dotfiles config --local status.showUntrackedFiles no && \
    dotfiles config user.name "Valentin Klammer" && \
    dotfiles config user.email "klmmmv@gmail.com" && \
    dotfiles checkout

COPY vim-requirements.txt /tmp
COPY install_vim_plugins.sh /tmp

RUN mkdir -p $HOME/.vim/bundle $HOME/.vim/autoload && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    chmod +x /tmp/install_vim_plugins.sh && \
    /tmp/install_vim_plugins.sh
