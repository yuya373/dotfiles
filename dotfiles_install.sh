#!/bin/bash
set -e
case ${OSTYPE} in
    darwin*)
        mkdir -p ~/.config/karabiner/
        ln -sf ~/dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
        sudo ln -sf ~/dotfiles/Library/LaunchDaemons/limit.maxfiles.plist /Library/LaunchDaemons/limit.maxfiles.plist
        ;;
    linux*)
        ln -sf ~/dotfiles/.aspell.conf  ~/.aspell.conf
        ln -sf ~/dotfiles/.zlogin  ~/.zlogin
        # X
        ln -sf ~/dotfiles/.xscreensaver  ~/.xscreensaver
        ln -sf ~/dotfiles/.Xresources  ~/.Xresources
        ln -sf ~/dotfiles/.xbindkeysrc  ~/.xbindkeysrc
        sudo ln -sf ~/dotfiles/etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
        sudo ln -sf ~/dotfiles/etc/X11/xorg.conf.d/10-monitor.conf  /etc/X11/xorg.conf.d/10-monitor.conf
        sudo ln -sf ~/dotfiles/etc/X11/xorg.conf.d/29-trackpoint.conf /etc/X11/xorg.conf.d/29-trackpoint.conf
        if [[ ! -d ~/.config/dunst ]]; then
            mkdir -p ~/.config/dunst
        fi
        ln -sf ~/dotfiles/.config/dunst/dunstrc ~/.config/dunst/dunstrc
        if [[ ! -d ~/.config/zathura ]]; then
            mkdir -p ~/.config/zathura
        fi
        ln -sf ~/dotfiles/.config/zathura/zathurarc ~/.config/zathura/zathurarc
        if [[ ! -d ~/.config/fontconfig/conf.d ]]; then
            mkdir -p ~/.config/fontconfig/conf.d
        fi
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/50-enable-terminal-powerline.conf ~/.config/fontconfig/conf.d/50-enable-terminal-powerline.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/71-no-embedded-bitmaps.conf  ~/.config/fontconfig/conf.d/71-no-embedded-bitmaps.conf
        # ln -sf ~/dotfiles/.config/fontconfig/conf.d/72-use-twitter-color-emoji.conf ~/.config/fontconfig/conf.d/72-use-twitter-color-emoji.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/73-sharp-font.conf  ~/.config/fontconfig/conf.d/73-sharp-font.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/74-japanese.conf  ~/.config/fontconfig/conf.d/74-japanese.conf
        ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf
        if [[ ! -d ~/.docker ]]; then
            mkdir -p ~/.docker
        fi
        ln -sf ~/dotfiles/.docker/config.json  ~/.docker/config.json
        mkdir -p ~/.xmonad
        ln -sf ~/dotfiles/xmonad.hs ~/.xmonad/xmonad.hs
        # xkeysnail
        # NOTE: need restart?
        sudo ln -sf ~/dotfiles/etc/modules-load.d/uinput.conf /etc/modules-load.d/uinput.conf
        sudo ln -sf ~/dotfiles/etc/udev/rules.d/29-input.rules /etc/udev/rules.d/29-input.rules
        sudo ln -sf ~/dotfiles/etc/udev/rules.d/30-uinput.rules  /etc/udev/rules.d/30-uinput.rules
        sudo ln -sf ~/dotfiles/etc/udev/rules.d/99-ergodox.rules /etc/udev/rules.d/99-ergodox.rules
        ln -sf ~/dotfiles/.config/systemd/user/ergodox.service ~/.config/systemd/user/ergodox.service
        mkdir -p ~/.config/systemd/user
        ln -sf ~/dotfiles/.config/systemd/user/ssh-agent.service ~/.config/systemd/user/ssh-agent.service
        ln -sf ~/dotfiles/.config/systemd/user/xkeysnail.service ~/.config/systemd/user/xkeysnail.service
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

# sbt
if [[ ! -d ~/.sbt/0.13/plugins ]]; then
    mkdir -p ~/.sbt/0.13/plugins/
fi

ln -sf ~/dotfiles/.sbt/0.13/plugins/plugins.sbt ~/.sbt/0.13/plugins/plugins.sbt
ln -sf ~/dotfiles/.sbt/0.13/plugins/build.sbt ~/.sbt/0.13/plugins/build.sbt

echo "Finished"

