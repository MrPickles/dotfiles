#!/usr/bin/env bash
set -euo pipefail

brew_bin=""

if [[ $(uname -s) != "Darwin" ]]; then
  echo "This script should be run on macOS only." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
  brew_bin=$(command -v brew)
  eval "$("${brew_bin}" shellenv)"
else
  echo "Unable to find Homebrew after installation." >&2
  exit 1
fi
hash -r

brew update
brew install \
  bat \
  eza \
  fd \
  fzf \
  git-delta \
  jq \
  neovim \
  reattach-to-user-namespace \
  ripgrep \
  tmux \
  tree-sitter-cli \
  zoxide

# ----------------------------------------------------
# Global System Preferences
# ----------------------------------------------------

# Always show scroll bars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Click scroll bar to jump where clicked
defaults write NSGlobalDomain AppleScrollerPagingBehavior -int 1

# Enable tap to click (trackpad and bluetooth trackpad)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Max out trackpad sensitivity (scaling to 3)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3

# Show Battery Percentage in Menu Bar
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true

# Show Sound Level in Menu Bar
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

# Disable Spotlight icon in Menu Bar
defaults write com.apple.controlcenter "NSStatusItem Visible Spotlight" -bool false

# Disable auto-correct, auto-capitalization, period substitution, and smart quotes/dashes
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Automatically hide and show the menu bar -> Never
defaults write NSGlobalDomain _HIHideMenuBar -bool false

# Clear all text replacements
defaults write NSGlobalDomain NSUserDictionaryReplacementItems -array

# ----------------------------------------------------
# Dock & Spaces Preferences
# ----------------------------------------------------

# Enable Dock autohide
defaults write com.apple.dock autohide -bool true

# Remove hide delay for the dock.
# https://apple.stackexchange.com/a/46222
defaults write com.apple.dock autohide-delay -float 0

# Remove Dock autohide animation delay (instant slide-in)
defaults write com.apple.dock autohide-time-modifier -float 0

# Scale effect instead of genie effect
defaults write com.apple.dock mineffect -string "scale"

# Disable recent apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Disable "Automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

# Hot Corners: Top-Right -> Notification Center (12), Bottom-Right -> Disabled (1)
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

killall Dock

# ----------------------------------------------------
# Finder Preferences
# ----------------------------------------------------

# Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar
defaults write com.apple.finder ShowStatusBar -bool true

# Default new windows to Home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Search within current folder by default instead of entire Mac
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Hide standard hard drives from the desktop, show external/removable media
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Configure Finder Toolbar (Top Bar) arrangement (requires plutil to nest array inside dictionary)
defaults read com.apple.finder >/dev/null # Ensure the plist file exists
plutil -replace "NSToolbar Configuration Browser" -json '{
  "TB Is Shown": true,
  "TB Icon Size Mode": 1,
  "TB Size Mode": 1,
  "TB Display Mode": 2,
  "TB Item Identifiers": [
    "com.apple.finder.BACK",
    "com.apple.finder.QUIK",
    "NSToolbarSpaceItem",
    "com.apple.finder.SWCH",
    "com.apple.finder.ARNG",
    "NSToolbarSpaceItem",
    "com.apple.finder.INFO",
    "com.apple.finder.ACTN",
    "NSToolbarSpaceItem",
    "com.apple.finder.SRCH"
  ]
}' ~/Library/Preferences/com.apple.finder.plist

# Hide the "Tags" section from the sidebar
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool false

killall Finder
