#!/bin/bash
set -e

# WSL環境かどうかを判定
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
    echo "🖥️  WSL環境を検出しました"
else
    echo "🐧 物理Linux環境を検出しました"
fi

# OS固有の設定
case ${OSTYPE} in
    darwin*)
        # mkdir -p ~/.config/karabiner/
        # ln -sf ~/dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json
        # sudo ln -sf ~/dotfiles/Library/LaunchDaemons/limit.maxfiles.plist /Library/LaunchDaemons/limit.maxfiles.plist
        # mkdir -p ~/Library/Preferences/
        # ln -sf ~/dotfiles/home/Library/Preferences/com.amethyst.Amethyst.plist ~/Library/Preferences/com.amethyst.Amethyst.plist
        ;;
    linux*)
        ln -sf ~/dotfiles/.aspell.conf ~/.aspell.conf

        # 物理Linux環境のみの設定
        if [[ "$IS_WSL" == false ]]; then
            ln -sf ~/dotfiles/.alacritty.yml ~/.alacritty.yml
            ln -sf ~/dotfiles/.zlogin ~/.zlogin

            # X11関連
            ln -sf ~/dotfiles/.xinitrc ~/.xinitrc
            ln -sf ~/dotfiles/.xscreensaver ~/.xscreensaver
            ln -sf ~/dotfiles/.Xresources ~/.Xresources
            ln -sf ~/dotfiles/.xbindkeysrc ~/.xbindkeysrc
            sudo ln -sf ~/dotfiles/etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
            sudo ln -sf ~/dotfiles/etc/X11/xorg.conf.d/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
            sudo ln -sf ~/dotfiles/etc/X11/xorg.conf.d/29-trackpoint.conf /etc/X11/xorg.conf.d/29-trackpoint.conf

            # デスクトップ環境関連
            if [[ ! -d ~/.config/dunst ]]; then
                mkdir -p ~/.config/dunst
            fi
            ln -sf ~/dotfiles/.config/dunst/dunstrc ~/.config/dunst/dunstrc

            if [[ ! -d ~/.config/zathura ]]; then
                mkdir -p ~/.config/zathura
            fi
            ln -sf ~/dotfiles/.config/zathura/zathurarc ~/.config/zathura/zathurarc

            ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf

            # xmonad
            mkdir -p ~/.xmonad
            ln -sf ~/dotfiles/xmonad.hs ~/.xmonad/xmonad.hs
            ln -sf ~/dotfiles/.xmobarrc ~/.xmobarrc

            # xkeysnail
            # NOTE: need restart?
            sudo ln -sf ~/dotfiles/etc/modules-load.d/uinput.conf /etc/modules-load.d/uinput.conf
            sudo ln -sf ~/dotfiles/etc/udev/rules.d/29-input.rules /etc/udev/rules.d/29-input.rules
            sudo ln -sf ~/dotfiles/etc/udev/rules.d/30-uinput.rules /etc/udev/rules.d/30-uinput.rules
            sudo ln -sf ~/dotfiles/etc/udev/rules.d/99-ergodox.rules /etc/udev/rules.d/99-ergodox.rules
        fi

        # sysctl設定 (Linux共通 - WSL/物理環境両対応)
        sudo ln -sf ~/dotfiles/etc/sysctl.d/99-pipe-max-size.conf /etc/sysctl.d/99-pipe-max-size.conf

        # fontconfig (Linux共通)
        if [[ ! -d ~/.config/fontconfig/conf.d ]]; then
            mkdir -p ~/.config/fontconfig/conf.d
        fi
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/50-enable-terminal-powerline.conf ~/.config/fontconfig/conf.d/50-enable-terminal-powerline.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/71-no-embedded-bitmaps.conf ~/.config/fontconfig/conf.d/71-no-embedded-bitmaps.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/73-sharp-font.conf ~/.config/fontconfig/conf.d/73-sharp-font.conf
        ln -sf ~/dotfiles/.config/fontconfig/conf.d/74-japanese.conf ~/.config/fontconfig/conf.d/74-japanese.conf

        # docker
        if [[ ! -d ~/.docker ]]; then
            mkdir -p ~/.docker
        fi
        ln -sf ~/dotfiles/.docker/config.json ~/.docker/config.json

        # systemd
        mkdir -p ~/.config/systemd/user
        ln -sf ~/dotfiles/.config/systemd/user/ssh-agent.service ~/.config/systemd/user/ssh-agent.service

        # 環境固有のsystemd services
        if [[ "$IS_WSL" == true ]]; then
            # WSL固有
            ln -sf ~/dotfiles/.config/systemd/user/yaskkserv2.service ~/.config/systemd/user/yaskkserv2.service
        else
            # 物理環境固有
            ln -sf ~/dotfiles/.config/systemd/user/ergodox.service ~/.config/systemd/user/ergodox.service
            ln -sf ~/dotfiles/.config/systemd/user/xkeysnail.service ~/.config/systemd/user/xkeysnail.service
            # sudo ln -sf ~/dotfiles/etc/systemd/system/phonesim.service /etc/systemd/system/phonesim.service
            # sudo ln -sf ~/dotfiles/etc/ofono/phonesim.conf /etc/ofono/phonesim.conf
        fi

        # systemdサービスを有効化
        echo "⚙️  systemdサービスを有効化中..."
        systemctl --user daemon-reload

        # 共通サービス
        systemctl --user enable ssh-agent.service

        # 環境固有のサービス有効化
        if [[ "$IS_WSL" == true ]]; then
            # WSL固有
            systemctl --user enable yaskkserv2.service
            echo "✅ yaskkserv2.serviceを有効化しました"
        else
            # 物理環境固有
            systemctl --user enable ergodox.service
            systemctl --user enable xkeysnail.service
            echo "✅ ergodox.service と xkeysnail.service を有効化しました"
        fi
        ;;
esac

# ==== 共通設定 ====

# git
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# vim
ln -sf ~/dotfiles/.vimrc ~/.vimrc

# zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zprompt ~/.spaceshiprc.zsh
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc

# bash
ln -sf ~/dotfiles/.bashrc ~/.bashrc

# tmux
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

mkdir -p ~/.config/tmux-powerline
ln -sf ~/dotfiles/tmux-powerline/config.sh ~/.config/tmux-powerline/config.sh

# emacs
ln -sf ~/dotfiles/.emacs.d ~/.emacs.d

# gems
ln -sf ~/dotfiles/.gemrc ~/.gemrc
ln -sf ~/dotfiles/.pryrc ~/.pryrc

# rust
if [[ ! -d ~/.cargo ]]; then
    mkdir -p ~/.cargo
fi
ln -sf ~/dotfiles/.cargo/config ~/.cargo/config.toml

# rubocop
ln -sf ~/dotfiles/.rubocop.yml ~/.rubocop.yml

# bat
mkdir -p ~/.config/bat
ln -sf ~/dotfiles/.config/bat/config ~/.config/bat/config

# mise
mkdir -p ~/.config/mise
ln -sf ~/dotfiles/.config/mise/config.toml ~/.config/mise/config.toml

# claude
mkdir -p ~/.claude
ln -sf ~/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -sf ~/dotfiles/claude/output-styles ~/.claude/output-styles

echo "✨ Finished"
