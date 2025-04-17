#!/bin/sh

# Enable auto-hide for the Dock
defaults write com.apple.dock autohide -bool true && killall Dock

# Set the auto-hide delay to a very long time (effectively disabling it)
# Use 4 fingers up gesture to show the Dock
defaults write com.apple.dock autohide-delay -float 1000 && killall Dock

# Disable dock bouncing
defaults write com.apple.dock no-bouncing -bool TRUE && killall Dock

# Disable window animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Move windows by holding ctrl+cmd and dragging anywhere
defaults write -g NSWindowShouldDragOnGesture -bool true
