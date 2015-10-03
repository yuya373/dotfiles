set -e

cd ~

git clone https://github.com/erikw/tmux-powerline.git

brew tap homebrew/dupes
brew install grep --default-names

brew tap sanemat/font
brew install --vim-powerline ricty

cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

git clone git@github.com:thewtex/tmux-mem-cpu-load.git
cd tmux-mem-cpu-load
cmake .
make
make install
