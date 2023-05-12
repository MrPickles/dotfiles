#!/usr/bin/env bash

# Remove hide delay for the dock
# https://apple.stackexchange.com/a/46222
defaults write com.apple.Dock autohide-delay -float 0; killall Dock
