set -e
case ${OSTYPE} in
    darwin*)
    ;;
    linux*)
        # X
        ln -sf ~/dotfiles/.Xresources  ~/.Xresources
        ln -sf ~/dotfiles/.Xmodmap  ~/.Xmodmap
        ln -sf ~/dotfiles/SandS  ~/SandS
        ;;
esac

# git
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# vim
# ln -sf ~/dotfiles/.vimrc ~/.vimrc
# ln -sf ~/dotfiles/.vimshrc ~/.vimshrc
# ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
# ln -sf ~/dotfiles/.xvimrc ~/.xvimrc

# zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv

# tmux
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -d ~/tmux-powerline ]]; then
    git clone https://github.com/erikw/tmux-powerline.git ~/tmux-powerline
fi

ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tmux-powerlinerc.default ~/.tmux-powerlinerc

# lisp
if [[ ! -d ~/.config/common-lisp ]]; then
    mkdir -p ~/.config/common-lisp
fi

if [[ ! -d ~/dev/cl ]]; then
    mkdir -p ~/dev/cl
fi

ln -sf ~/dotfiles/.config/common-lisp/source-registry.conf ~/.config/common-lisp/source-registry.conf
ln -sf ~/dotfiles/.sbclrc ~/.sbclrc

# emacs
ln -sf ~/dotfiles/.emacs.d ~/.emacs.d

# eslint
ln -sf ~/dotfiles/.eslintrc  ~/.eslintrc

# sshrc
ln -sf ~/dotfiles/.sshrc ~/.sshrc

# gems
ln -sf ~/dotfiles/.gemrc  ~/.gemrc

ln -sf ~/dotfiles/.pryrc  ~/.pryrc

# rust
if [[ ! -d ~/.cargo ]]; then
    mkdir -p ~/.cargo
fi
ln -sf ~/dotfiles/.cargo/config ~/.cargo/config

# rubocop
ln -sf ~/dotfiles/.rubocop.yml  ~/.rubocop.yml

# npm
ln -sf ~/dotfiles/.npmrc ~/.npmrc

echo "Finished"

