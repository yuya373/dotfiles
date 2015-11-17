set -e

# home brew setup
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install rcmdnk/file/brew-file

brew file set_repo yuya373/brewfile
brew file install
cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

echo "Finished"
