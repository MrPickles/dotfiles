# Provisioning a New Machine

New machines require two tasks to be done which are not part of the setup
script: installing (and using) Powerline-compatible fonts and using the
Solarized colorscheme. This configuration uses a zsh theme similar to Agnoster.
It also uses Powerline for vim and tmux. As a result, you'll need to install
patched fonts that support Powerline.

## Linux

### Powerline Fonts

Follow these commands to patch the font.

```bash
cd ~/.dotfiles/new_machine
mkdir -p ~/.fonts/
cp PowerlineSymbols.otf ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d
fc-cache -vf ~/.fonts/
cp 10-powerline-symbols.conf ~/.config/fontconfig/conf.d
```

### Solarized on Linux

Create a new profile on the terminal emulator.

  ![Creating a new terminal profile](images/newprofile.png)

Set that profile to be the default profile upon terminal open.

  ![Using solarized as the default terminal](images/newterminal.png)

Run the setup script for solarized.

```bash
cd ~/.dotfiles/new_machine/gnome-terminal-colors-solarized
./set_dark.sh
```

## Enable Copy/Paste in Tmux on OSX
On Macs, `pbcopy` and `pbpaste` don't natively work in tmux. Luckly there's a
[Homebrew](http://brew.sh/) formula to fix that.

```bash
brew install reattach-to-user-namespace
```

The tmux configuration will do the rest for you. Note that this only applies to
machines running OSX.

