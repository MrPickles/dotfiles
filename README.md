# Dotfiles!

These are my personal dotfiles.

These dotfiles are best used with zsh,
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), and the
[solarized](http://ethanschoonover.com/solarized) colorscheme. The configuration
has [powerline](https://github.com/powerline/powerline) active for vim and tmux,
and uses a custom zsh theme similar to agnoster. Thus you'll need to patch to a
font that supports powerline.

## Installation
Installation is as simple as cloning the repo and running the setup script. The
script will fetch oh-my-zsh and symlink the dotfiles to your home directory.

```bash
git clone https://github.com/MrPickles/dotfiles.git --recursive ~/.dotfiles
cd ~/.dotfiles/new_machine
```

If you forgot to clone the submodules, you can run `git submodule update --init`
to get them after cloning the main repo.

You will need to set up solarized and compatible fonts before running the setup
script. There are files in the `new_machine` directory that can be used to set
up these prerequisites. See the [README](new_machine/README.md) in the that
directory for instructions. This part is optional if these dotfiles are being
reinstalled.

Installing the dotfiles is as simple as running the setup script.

```bash
cd ~/.dotfiles
./configure.sh build
```

## Customizing
You can customize vim, git, and zsh for each specific machine. Just put any
additional configurations in `~/.zshrc.local` or `~/.vimrc.local`. Sample local
configs are included in this repo. Custom git configurations can just be placed
in `.gitconfig`.

## Teardown
To clean up the dotfiles, run the teardown script. It will remove all symlinks,
but zsh and oh-my-zsh will be untouched.

```bash
cd ~/.dotfiles
./configure.sh clean
rm -rf ~/.oh-my-zsh # optionally remove oh-my-zsh
chsh -s `which bash` # optionally change shell back to bash
```

## Other dotfiles
Here are some repos that I cherry-pick useful stuff from. :)
* [Unofficial Dotfile Guide](http://dotfiles.github.io/)
* [Nick's Dotfiles](https://github.com/nicksp/dotfiles)
* [Ryan's Dotfiles](https://github.com/ryanb/dotfiles)
* [YADR](https://github.com/skwp/dotfiles)

