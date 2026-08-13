#!/usr/bin/env bash
# macOS defaults. Previously prose in the README; now runnable.
# Safe to re-run. Log out (or restart the affected app) for everything to apply.
set -euo pipefail

echo "==> keyboard"
# Key repeat speed pls
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
# No smart quotes / dashes / autocorrect while writing code
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
# Full keyboard access: tab through every control in dialogs
defaults write -g AppleKeyboardUIMode -int 3
# Hold-key repeats instead of showing the accent picker
defaults write -g ApplePressAndHoldEnabled -bool false

echo "==> trackpad and mouse"
# Invert scroll on touchpad
defaults write -g com.apple.swipescrolldirection -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write -g com.apple.mouse.tapBehavior -int 1

echo "==> dock"
# Rm all stuff from toolbar
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock mineffect -string "scale"

echo "==> hot corners"
# 1 disabled | 2 mission control | 4 desktop | 5 screen saver
# 10 display sleep | 11 launchpad | 12 notification centre | 14 quick note
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0

echo "==> finder"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write -g AppleShowAllExtensions -bool true
# No .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "==> screenshots"
mkdir -p "$HOME/Desktop/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Desktop/screenshots"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"

echo "==> misc"
# Expand save and print dialogs by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
# Save to disk, not iCloud, by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
# No "are you sure you want to open this" for downloaded apps
defaults write com.apple.LaunchServices LSQuarantine -bool false

killall Dock Finder SystemUIServer 2>/dev/null || true

cat <<'MANUAL'

Done. Still manual, no defaults key exists for these:

  - Remap caps lock to control
      System Settings -> Keyboard -> Keyboard Shortcuts -> Modifier Keys
      (skip if your keyboard firmware already does it)
  - Pair the bluetooth mouse
  - Rectangle: grant accessibility permission, import your shortcut config
  - Ghostty: grant accessibility permission (the nvim keybind table uses AppleScript)
  - 1Password: browser integration in Firefox and Chrome
  - Tailscale: sign in
  - Run all pending macOS updates

MANUAL
