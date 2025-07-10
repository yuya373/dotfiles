typeset -U path cdpath fpath manpath

if [ ! -d $HOME/.zfunctions ]; then
    echo "creating $HOME/.zfunctions ..."
    mkdir -p $HOME/.zfunctions
fi
fpath=("$HOME/.zfunctions" $fpath)

if [[ ! -d $ZPLUG_HOME ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

# zplug
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "babarot/zsh-vimode-visual", defer:3

zplug "spaceship-prompt/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "spaceship-prompt/spaceship-vi-mode"

zplug "babarot/enhancd", use:init.sh
zplug "sorin-ionescu/prezto", use:init.zsh

zplug "junegunn/fzf"

zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
# autosuggestions

zplug load


source ~/dotfiles/tmux.zsh

ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(do_enter kill-line $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)

source ~/dotfiles/.zshfunc
source ~/dotfiles/.zsh_keybind
source ~/dotfiles/.zsh_aliases
if [ -e $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

# dircolors
eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`


# Customize to your needs...
setopt NO_BEEP
setopt nonomatch

case ${OSTYPE} in
    darwin*)
        # for brew-file
        if [ -f $(brew --prefix)/etc/brew-wrap ];then
            source $(brew --prefix)/etc/brew-wrap
        fi
        alias mc='~/dotfiles/google_chrome'
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
        fpath=("/usr/local/share/zsh/site-functions" $fpath)
        ;;
    linux*)
        # ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
        ;;
esac

# [zsh の zmv を使って簡単に複数ファイルを一括リネームする - mollifier delta blog](http://mollifier.hatenablog.com/entry/20101227/p1)
autoload -Uz zmv
alias zmv='noglob zmv -W'

# rust
alias rust='cargo-script'

# Fix zsh: command not found: tmuximum
unalias t

[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/zsh"

# fzf設定を読み込む
source ~/dotfiles/.zsh_fzf
