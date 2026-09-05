# The Official&trade; MrPickles Dotfiles Repository

These are my personal dotfiles.

```
curl https://raw.githubusercontent.com/MrPickles/dotfiles/master/scripts/dotfiles.sh | bash
```

![Screenshot of my dotfiles](.github/screenshot.png)

They use zsh, [oh-my-zsh][], and [Tokyo Night][tokyonight], with
[Powerlevel10k][powerlevel10k] as the prompt.

## Try it out in Docker

The easiest way to try the environment is the [Docker image][docker-hub]:

```shell
docker run -it docker.io/liuandrewk/dotfiles
```

Use a terminal with Powerline/Nerd Fonts (see fonts below) or the prompt will
look wrong. Everything else should work as-is.

## Prerequisites

* Linux, macOS, or WSL
* Neovim (latest stable)
* [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter) — required;
  Neovim depends on it

## Installation

Run this command:

```shell
curl https://raw.githubusercontent.com/MrPickles/dotfiles/master/scripts/dotfiles.sh | bash
```

That clones the repo if needed, fetches oh-my-zsh, and symlinks into your home
directory. You can also clone the repository:

```shell
git clone --filter=blob:none git@github.com:MrPickles/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

If the login shell is not already zsh:

```shell
chsh -s $(which zsh)
```

Run `./setup.sh` again later to refresh oh-my-zsh plugins and recreate
symlinks.

## Fresh machine

The setup script can also install various system dependencies.

`--install-deps` is opinionated and meant for a blank computer. It installs
packages (and, on macOS, system defaults) and then does the usual `./setup.sh`
link step.

```shell
./setup.sh --install-deps
```

On macOS, `--install-deps` runs `scripts/macos.sh`, which installs Homebrew and
the `Brewfile`, along with Finder/Dock/trackpad defaults.

On Linux it runs `scripts/linux.sh`, which installs a small apt bootstrap
(compiler toolchain, curl, git, zsh, vim) and then the same Homebrew `Brewfile`.
CLI tools are managed by brew on both operating systems. Casks and Mac App Store
apps stay macOS-only. Homebrew's Linux bottles target Ubuntu 24.04+ (glibc
2.39); older Debian/Ubuntu still work, but the first install is slower.

## Fonts and colors

The terminal prompts require Nerd Fonts of some sort.
The font recommended by Powerlevel10k is [MesloLGS NF][p10k-fonts].

If bat (or delta, which uses bat's themes) looks unthemed, rebuild the cache:

```shell
bat cache --build
```

## Optional tools

`./setup.sh --install-deps` can install these. They are optional but improve the
shell:

* [bat](https://github.com/sharkdp/bat)
* [ripgrep](https://github.com/BurntSushi/ripgrep)
* [fd](https://github.com/sharkdp/fd)
* [eza](https://github.com/eza-community/eza)
* [fzf](https://github.com/junegunn/fzf)
* [delta](https://github.com/dandavison/delta)

## Customizing

Per-machine overrides (not in git):

* `~/.zshenv.local`
* `~/.zshrc.local`
* `~/.vimrc.local`
* `~/.tmux.conf.local`

Git: shared config is `config/git/config` and is included for you. Put tokens
and host-specific settings in `~/.gitconfig`.

Jujutsu: shared config is `config/jj/config.toml`. Put private settings in
`~/.jjconfig.toml`. jj merges the two automatically.

## Docker

Build a local image:

```shell
docker build -t liuandrewk/dotfiles .
docker run -it liuandrewk/dotfiles
```

The container is ephemeral unless you mount a volume.

## Teardown

```shell
cd ~/.dotfiles
./setup.sh --clean
rm -rf ~/.oh-my-zsh   # optional
chsh -s $(which bash) # optional
```

`--clean` removes the symlinks. zsh and oh-my-zsh are left in place.

[tokyonight]: https://github.com/folke/tokyonight.nvim
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[p10k-fonts]: https://github.com/romkatv/powerlevel10k/#meslo-nerd-font-patched-for-powerlevel10k
[powerlevel10k]: https://github.com/romkatv/powerlevel10k
[docker-hub]: https://hub.docker.com/r/liuandrewk/dotfiles
