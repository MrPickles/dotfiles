# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN apt update && apt install -y \
  ca-certificates \
  sudo \
  zsh

# Create a user with sudo privileges.
ARG USER=andy
RUN useradd -rm -d /home/${USER} -s $(which zsh) -g root -G sudo ${USER}
RUN chown -R ${USER} /home/${USER}
RUN echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}

# Copy over dotfiles and switch to the non-root user.
COPY . /home/${USER}/.dotfiles
RUN chown -R ${USER} /home/${USER}
USER ${USER}

WORKDIR /home/${USER}/.dotfiles
RUN ./setup.sh --install-deps

# Install gitstatusd.
RUN /home/${USER}/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install

# Install Neovim plugins.
RUN nvim --headless "+Lazy! sync" +qa

# Install vim plugins.
RUN vim +PlugInstall +qa

WORKDIR /home/${USER}
ENTRYPOINT zsh
