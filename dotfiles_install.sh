set -e

# git
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# vim
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vimshrc ~/.vimshrc
ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.xvimrc ~/.xvimrc

# zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv

# prezto
if [[ ! -d ~/.zprezto ]]; then
    ln -sf ~/dotfiles/.zprezto ~/.zprezto
fi
ln -sf ~/dotfiles/.zprezto/runcoms/zlogin ~/.zlogin
ln -sf ~/dotfiles/.zprezto/runcoms/zlogout ~/.zlogout
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc
ln -sf ~/dotfiles/.zprofile ~/.zprofile

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
if [[ ! -d ~/.emacs.d ]]; then
    mkdir ~/.emacs.d/
fi
ln -sf ~/dotfiles/.emacs.d/init.el ~/.emacs.d/init.el

# eslint
ln -sf ~/dotfiles/.eslintrc  ~/.eslintrc

echo "Finished"

