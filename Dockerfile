# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN apt update && apt install -y \
  build-essential \
  curl \
  exa \
  git \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zsh

WORKDIR /tmp

# Install Neovim via dpkg
RUN wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb \
  && dpkg -i nvim-linux64.deb \
  && rm nvim-linux64.deb

# Install git-delta via dpkg
RUN wget https://github.com/dandavison/delta/releases/download/0.14.0/git-delta-musl_0.14.0_amd64.deb \
  && dpkg -i git-delta-musl_0.14.0_amd64.deb \
  && rm git-delta-musl_0.14.0_amd64.deb

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
RUN ./setup.sh

# Install gitstatusd
RUN /home/${USER}/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install

# Install Neovim plugins
#
# 1) The first headless run bootstraps Packer.
# 2) The second headless run installs the Packer plugins.
# 3) Finally, we install the Treesitter parsers.
#    Note that we have to guess when installation will be done.
#    Unfortunately, there's no completion callback for us to detect.
#
# See https://github.com/wbthomason/packer.nvim/issues/502 for more details.
RUN nvim --headless +qa \
  && nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync" \
  && nvim --headless -c "TSInstall" +"sleep 40" +qa

# Install vim plugins
RUN vim +PlugInstall +qa

WORKDIR /home/${USER}
ENTRYPOINT zsh
