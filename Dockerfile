# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    NONINTERACTIVE=1 \
    HOMEBREW_NO_ANALYTICS=1 \
    PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  sudo \
  zsh \
  && rm -rf /var/lib/apt/lists/*

# Create a user with sudo privileges. Homebrew must not run as root.
ARG USER=andy
RUN useradd -rmU -d /home/${USER} -s "$(command -v zsh)" -G sudo ${USER} \
  && echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} \
  && chmod 0440 /etc/sudoers.d/${USER}

# Copy bootstrap inputs first so Brewfile installs stay cached.
WORKDIR /tmp/dotfiles-bootstrap
COPY --chown=${USER}:${USER} scripts ./scripts
COPY --chown=${USER}:${USER} Brewfile ./
USER ${USER}
RUN chmod +x ./scripts/linux.sh \
  && ./scripts/linux.sh \
  && sudo rm -rf /var/lib/apt/lists/*

USER root
COPY --chown=${USER}:${USER} . /home/${USER}/.dotfiles
USER ${USER}
WORKDIR /home/${USER}/.dotfiles

RUN ./setup.sh

# Install gitstatusd.
RUN /home/${USER}/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install

# Install Neovim plugins.
RUN nvim --headless "+Lazy! sync" +qa

# Install vim plugins.
RUN vim +PlugInstall +qa

WORKDIR /home/${USER}
ENTRYPOINT ["zsh"]
