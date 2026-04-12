# syntax=docker/dockerfile:1
FROM ubuntu:24.04

RUN apt update && apt install -y \
  ca-certificates \
  sudo \
  zsh

WORKDIR /tmp/dotfiles-bootstrap
COPY scripts/common.sh ./scripts/common.sh
COPY scripts/linux.sh ./scripts/linux.sh
RUN chmod +x ./scripts/linux.sh && ./scripts/linux.sh --tool-source distro

# Create a user with sudo privileges.
ARG USER=andy
RUN useradd -rm -d /home/${USER} -s $(which zsh) -g root -G sudo ${USER}
RUN chown -R ${USER} /home/${USER}
RUN echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}

# Copy over dotfiles.
COPY . /home/${USER}/.dotfiles
RUN chown -R ${USER} /home/${USER}

WORKDIR /home/${USER}/.dotfiles

USER ${USER}
RUN ./setup.sh

# Install gitstatusd.
RUN /home/${USER}/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install

# Install Neovim plugins.
RUN nvim --headless "+Lazy! sync" +qa

# Install vim plugins.
RUN vim +PlugInstall +qa

WORKDIR /home/${USER}
ENTRYPOINT ["zsh"]
