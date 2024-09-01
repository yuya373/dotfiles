#!/bin/bash
set -e
case ${OSTYPE} in
    linux*)
        ln -sf ~/dotfiles/.aspell.conf  ~/.aspell.conf
        # X
        # ln -sf ~/dotfiles/.Xresources  ~/.Xresources
        if [[ ! -d ~/.config/fontconfig/conf.d ]]; then
            mkdir -p ~/.config/fontconfig/conf.d
        fi
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/50-enable-terminal-powerline.conf ~/.config/fontconfig/conf.d/50-enable-terminal-powerline.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/71-no-embedded-bitmaps.conf  ~/.config/fontconfig/conf.d/71-no-embedded-bitmaps.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/73-sharp-font.conf  ~/.config/fontconfig/conf.d/73-sharp-font.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/74-japanese.conf  ~/.config/fontconfig/conf.d/74-japanese.conf
        if [[ ! -d ~/.docker ]]; then
            mkdir -p ~/.docker
        fi
        ln -sf ~/dotfiles/.docker/config.json  ~/.docker/config.json
        ;;
esac

# git
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# vim
ln -sf ~/dotfiles/.vimrc ~/.vimrc
# ln -sf ~/dotfiles/.vimshrc ~/.vimshrc
# ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
# ln -sf ~/dotfiles/.xvimrc ~/.xvimrc

# zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zprompt  ~/.spaceshiprc.zsh

# tmux
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -d ~/tmux-powerline ]]; then
    git clone https://github.com/erikw/tmux-powerline.git ~/tmux-powerline
fi

ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tmux-powerlinerc.default ~/.tmux-powerlinerc

# emacs
ln -sf ~/dotfiles/.emacs.d ~/.emacs.d
mkdir -p ~/.emacs.d/var/slack-images
mkdir -p ~/.emacs.d/var/slack-profile-images

# gems
ln -sf ~/dotfiles/.gemrc  ~/.gemrc

ln -sf ~/dotfiles/.pryrc  ~/.pryrc

# rust
if [[ ! -d ~/.cargo ]]; then
    mkdir -p ~/.cargo
fi
ln -sf ~/dotfiles/.cargo/config ~/.cargo/config
ln -sf ~/dotfiles/.cargo/config ~/.cargo/config.toml

# rubocop
ln -sf ~/dotfiles/.rubocop.yml  ~/.rubocop.yml

echo "Finished"

