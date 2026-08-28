# Formulae
brew "bat"
brew "eza"
brew "fd"
brew "fzf"
brew "git-delta"
brew "jj"
brew "jq"
brew "mosh"
brew "neovim"
brew "reattach-to-user-namespace"
brew "ripgrep"
brew "shellcheck"
brew "thefuck"
brew "tmux"
brew "tree-sitter-cli"
brew "wget"
brew "zoxide"

# Treat MDM enrollment as a signal that this is a managed work Mac.
mdm_enrolled = OS.mac? && IO.popen(
  ["/usr/bin/profiles", "status", "-type", "enrollment"],
  err: File::NULL,
  &:read
).include?("MDM enrollment: Yes")

if OS.mac? && !mdm_enrolled
  # Casks
  cask "1password"
  cask "aldente"
  cask "alfred"
  cask "chatgpt"
  cask "discord"
  cask "dropbox"
  cask "ghostty"
  cask "google-chrome"
  cask "iina"
  cask "notion-calendar"
  cask "obsidian"
  cask "signal"
  cask "spotify"
  cask "tailscale-app"
  cask "todoist-app"
  cask "vorssaint"

  # Mac App Store
  mas "Spark Classic - Email App", id: 1176895641
  mas "WeChat", id: 836500024
  mas "WhatsApp Messenger", id: 310633997
end
