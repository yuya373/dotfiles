#!/bin/bash
set -e

# home brew setup
if ! which brew > /dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew cask install \
     dash alfred bettertouchtool \
     aquaskk karabiner-elements bitbar \
     google-chrome dropbox vlc \
     trailer

# Android
# brew cask install \
#      android-platform-tools \
#      android-sdk


brew install
     git hub tmux zsh vim sshrc
     coreutils cmigemo ispell \
     direnv global ctags \
     the_silver_searcher \
     reattach-to-user-namespace \
     yarn \
     go dep hugo

# iOS
# brew install carthage

# Emacs
brew install emacs --with-cocoa --with-ctags --with-imagemagick@6 --with-librsvg --with-dbus --HEAD
ln -sf `brew --prefix emacs`/Emacs.app /Applications/Emacs.app
## makeinfo
brew install texinfo
## pdf-tools
brew install autoconf automake poppler
## emacs-slack
brew install terminal-notifier

brew tap sanemat/font
brew install ricty --with-patch-in-place
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf


echo "Finished"

