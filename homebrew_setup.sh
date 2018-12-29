#!/bin/bash
set -e

# home brew setup
if ! which brew > /dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew cask install dash alfred bettertouchtool \
     google-chrome karabiner-elements \
     bitbar android-platform-tools android-sdk \
     dropbox aquaskk

brew cask install xquartz
brew install cairo --with-x11

brew install git hub tmux vim sshrc coreutils zsh \
     cmigemo ispell \
     the_silver_searcher direnv global ctags \
     reattach-to-user-namespace \
     yarn hugo carthage \
     mono go dep

# build Emacs
# brew install autoconf
# brew install --build-from-source gnutls

brew install emacs --with-cocoa --with-ctags --with-imagemagick@6 --with-librsvg --with-dbus --HEAD
# pdf-tools
brew install autoconf automake poppler

brew install texinfo
brew link --force texinfo

brew tap sanemat/font
brew install ricty --with-patch-in-place
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf


echo "Finished"

