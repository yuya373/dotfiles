#!/bin/bash
set -e

# home brew setup
if ! which brew > /dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! which brew-file > /dev/null; then
    brew install rcmdnk/file/brew-file
    brew file set_repo yuya373/brewfile
    brew file install
    # ricty
    cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
    fc-cache -vf
    brew link openssl --force
fi

echo "Finished"

