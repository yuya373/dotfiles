set -e

# home brew setup
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install rcmdnk/file/brew-file

brew file set_repo yuya373/brewfile
brew file install
