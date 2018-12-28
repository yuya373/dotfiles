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

zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
zplug "seebi/dircolors-solarized"

zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-vimode-visual"

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "junegunn/fzf", use:"shell/*.zsh", as:plugin

zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

zplug "modules/completion", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/history", from:prezto
zplug "modules/autosuggestions", from:prezto
zplug "modules/history-substring-search", from:prezto
zplug "modules/rsync", from:prezto
zplug "modules/archive", from:prezto

case ${OSTYPE} in
    linux*)
        zplug "modules/pacman", from:prezto
esac

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
# autosuggestions
zstyle ':prezto:module:autosuggestions' color 'yes'
zstyle ':prezto:module:autosuggestions:color' found 'fg=136'
zstyle ':prezto:module:history-substring-search' color 'yes'
zstyle ':prezto:module:history-substring-search' case-sensitive 'yes'
zstyle ':notify:*' command-complete-timeout 1
zstyle ':prezto:module:pacman' frontend 'yaourt'

zplug load --verbose


source ~/dotfiles/tmux.zsh

ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(do_enter kill-line $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)

source ~/dotfiles/.zprompt
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
        ;;
    linux*)
        # ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
        ;;
esac

# [zsh の zmv を使って簡単に複数ファイルを一括リネームする - mollifier delta blog](http://mollifier.hatenablog.com/entry/20101227/p1)
autoload -Uz zmv
alias zmv='noglob zmv -W'

if (which zprof > /dev/null) ;then
    zprof | less
fi

# rust
alias rust='cargo-script'

eval "$(direnv hook zsh)"

# OPAM configuration
. /home/yuya373/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
