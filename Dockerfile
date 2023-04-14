# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN apt update && apt install -y \
  bat \
  build-essential \
  curl \
  exa \
  fd-find \
  git \
  ripgrep \
  software-properties-common \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zsh

WORKDIR /tmp

# Install neovim via PPA
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt update && apt install -y neovim

# Install git-delta via dpkg
ENV GIT_DELTA_VERSION="0.15.1"
ENV GIT_DELTA_DEB="git-delta-musl_${GIT_DELTA_VERSION}_amd64.deb"
RUN wget https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/${GIT_DELTA_DEB} \
  && dpkg -i ${GIT_DELTA_DEB} \
  && rm ${GIT_DELTA_DEB}

# Create a user with sudo privileges
ARG USER=andy
RUN useradd -rm -d /home/${USER} -s $(which zsh) -g root -G sudo ${USER}
RUN chown -R ${USER} /home/${USER}
RUN echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}

# Copy over dotfiles and switch to the non-root user
COPY . /home/${USER}/.dotfiles
RUN chown -R ${USER} /home/${USER}
USER ${USER}

# Install the dotfiles
WORKDIR /home/${USER}/.dotfiles
RUN ./setup.sh -t build

# Install gitstatusd
RUN /home/${USER}/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install

# Install Neovim plugins
RUN nvim --headless "+Lazy! sync" +qa

# Install vim plugins
RUN vim +PlugInstall +qa

WORKDIR /home/${USER}
ENTRYPOINT zsh
