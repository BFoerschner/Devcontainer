FROM ubuntu:24.04

ENV HOME=/root

RUN mkdir -p $HOME/.local/bin
COPY bin $HOME/.local/bin
COPY init_scripts $HOME/init_scripts
COPY init.sh $HOME/init.sh

RUN apt-get update 
RUN apt-get install -y software-properties-common
# neovim latest
RUN add-apt-repository ppa:neovim-ppa/unstable
# golang latest
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get update 
RUN apt-get install unminimize && yes | unminimize
RUN apt-get install -y \
  zsh \
  tmux \
  stow \
  git \
  neovim \
  curl \
  wget \
  docker.io \
  unzip \
  build-essential \
  cmake \
  nodejs \
  npm \
  python3 \
  python3-pip \
  python3-venv \
  golang-go \
  lua5.4 \
  luarocks \
  perl
#
# install uv, installing python tools properly
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && rm $HOME/.zshrc

# dotfiles for cozy dev environment
RUN git clone https://github.com/BFoerschner/dotfiles $HOME/.dotfiles && cd $HOME/.dotfiles && stow .

# Install tools from init_scripts folder
RUN chmod +x $HOME/init.sh && chmod -R +x $HOME/init_scripts
RUN $HOME/init.sh
RUN rm -rf $HOME/init_scripts && rm $HOME/init.sh

# change shell to zsh
RUN chsh -s /bin/zsh
# change workdir to imported volume
WORKDIR $HOME/host

ENTRYPOINT ["tmux", "-u"]

