#!/bin/bash
set -e

# home brew setup
if ! which brew > /dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install --cask \
     alfred bettertouchtool \
     aquaskk karabiner-elements \
     google-chrome dropbox vlc \
     trailer flux docker \
     sketch amethyst kap \


brew install \
     git gh tmux zsh vim \
     coreutils cmigemo ispell \
     direnv global ctags \
     the_silver_searcher \
     reattach-to-user-namespace \
     yarn watchman \
     go dep hugo \
     awscli tfenv \
     htop \
     openssl mysql \
     mutagen-io/mutagen/mutagen rsync packer \
     ghq

# iOS
# brew install carthage

# Emacs

# TODO: create own taps
# brew install emacs --with-cocoa --with-ctags --with-imagemagick --with-librsvg --with-dbus --HEAD
# ln -sf `brew --prefix emacs`/Emacs.app /Applications/Emacs.app

brew install imagemagick gnutls pkgconfig autoconf texinfo
~/dotfiles/build_emacs

## makeinfo
brew install texinfo
## pdf-tools
brew install autoconf automake poppler zlib
## emacs-slack
brew install terminal-notifier

brew tap sanemat/font
brew install ricty --with-patch-in-place
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf


echo "Finished"

