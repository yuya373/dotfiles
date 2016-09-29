# functions
if [ ! -d ${HOME}/.zfunctions ]; then
    mkdir -p ~/.zfunctions
fi
fpath=("$HOME/.zfunctions" $fpath)

source ~/dotfiles/.zprompt
source ~/dotfiles/.zshfunc
source ~/dotfiles/.zsh_keybind

# coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", nice:10
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

zplug "zsh-users/zsh-history-substring-search"
# zplug "sharat87/zsh-vim-mode"
zplug "sindresorhus/pure", use:"*.zsh"
zplug "seebi/dircolors-solarized"
zplug "m4i/cdd", use:"cdd", nice:10
zplug "zsh-users/zsh-completions", \
      hook-load: "fpath=("$ZPLUG_REPOS/zsh-users/zsh-completions" $fpath)"
zplug "b4b4r07/dotfiles", use:etc/lib/vital.sh, \
      hook-load: "export DOTPATH=$ZPLUG_HOME/repos/b4b4r07/dotfiles"
zplug "b4b4r07/dotfiles", use:bin/tmuxx, as:command
zplug "b4b4r07/enhancd", use:init.sh
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "junegunn/fzf", use:"shell/*.zsh"
zplug "sorin-ionescu/prezto", \
      use:"modules/{completion,directory,history,rsync}/*.zsh"
zplug "sorin-ionescu/prezto", \
      as:command, \
      use:"modules/archive/functions/*"
zplug "zsh-users/zsh-autosuggestions"
zplug "arks22/tmuximum", as:command
zplug "b4b4r07/zsh-vimode-visual"

# Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

# autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=136'
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(do_enter kill-line $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)

export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='+c -x --inline-info'

# dircolors
eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Customize to your needs...
setopt NO_BEEP

# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
autoload -Uz run-help
autoload -Uz run-help-git

#for brew-file
if [ -f $(brew --prefix)/etc/brew-wrap ];then
    source $(brew --prefix)/etc/brew-wrap
fi

if [ -e ${HOME}/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

setopt nonomatch

add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true


# cdd
chpwd() {
    _cdd_chpwd
}

# The next line updates PATH for the Google Cloud SDK.
# source '/Users/yuyaminami/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
# source '/Users/yuyaminami/google-cloud-sdk/completion.zsh.inc'

source ~/dotfiles/.zsh_aliases
if [ -d ${HOME}/.rbenv ] ; then
    eval "$(rbenv init - --no-rehash)"
fi

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init - --no-rehash)"
fi
# tmuxx

if (which zprof > /dev/null) ;then
    zprof | less
fi
