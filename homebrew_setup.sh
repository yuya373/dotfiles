#!/bin/bash
set -e

# home brew setup
if ! which brew > /dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# if ! which brew-file > /dev/null; then
#     brew install rcmdnk/file/brew-file
#     brew file set_repo yuya373/brewfile
#     brew file install
#     # ricty
#     cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
#     fc-cache -vf
#     brew link openssl --force
# fi

brew cask install dash alfred bettertouchtool \
     google-chrome karabiner-elements \
     bitbar

brew cask install xquartz
brew install cairo --with-x11

brew install git hub tmux vim sshrc coreutils zsh \
     the_silver_searcher direnv global ctags \
     sanemat/font/ricty reattach-to-user-namespace \
     yarn hugo


brew install texinfo
brew link --force texinfo


echo "Finished"

