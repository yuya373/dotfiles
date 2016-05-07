# Source Prezto.
# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi

# functions
if [ ! -d ${HOME}/.zfunctions ]; then
    mkdir -p ~/.zfunctions
fi
fpath=( "$HOME/.zfunctions" $fpath )

# coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

alias ls="ls -h --color"
alias ll="ls -l"
alias la="ls -al"

# zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", nice:10
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

zplug "zsh-users/zsh-history-substring-search", nice:11
zplug "sharat87/zsh-vim-mode"
zplug "sindresorhus/pure", use:"*.zsh"
zplug "seebi/dircolors-solarized"
zplug "m4i/cdd", use:"cdd", nice:10
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/dotfiles", use:etc/lib/vital.sh, hook-load:"export DOTPATH=$ZPLUG_HOME/repos/b4b4r07/dotfiles"
zplug "b4b4r07/dotfiles", use:bin/tmuxx, as:command
zplug "b4b4r07/enhancd", use:enhancd.sh
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "junegunn/fzf", use:shell/completion.zsh
zplug "junegunn/fzf", use:shell/key-bindings.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# pure
ln -sf "$ZPLUG_HOME/repos/sindresorhus/pure/pure.zsh" "$HOME/.zfunctions/prompt_pure_setup"
ln -sf "$ZPLUG_HOME/repos/sindresorhus/pure/async.zsh" "$HOME/.zfunctions/async"

# Then, source plugins and add commands to $PATH
zplug load --verbose

# dircolors
eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# prompt
source ~/dotfiles/.zprompt

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Customize to your needs...
setopt share_history

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
source ~/dotfiles/.zshfunc

# # terminal-notifier
# case "${OSTYPE}" in
#   darwin*)
#     source ~/dotfiles/zsh-notify/notify.plugin.zsh
#     ;;
# esac

# disable keyboard
alias disablekeyboard="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias enablekeyboard="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"

# Git
alias gs="git status"
alias gc="git checkout"
alias gcb="git checkout -b"
alias ga="git add"
alias gap="git add -p"
alias gp="git pull"
alias gcm="git commit"
alias gpu="git push"
alias gd="git diff"

# Emacs
alias e="emacsclient -n"
alias ee="emacsclient -nw -a ''"
alias build_emacs="git checkout master; git pull; make maintainer-clean; make clean; ./autogen.sh; ./configure --with-ns --without-x --with-gnutls --with-imagemagick --with-xml2 --with-rsvg --disable-ns-self-contained --with-modules --with-xwidgets; make -j2; make install;"
alias build_emacs25="git checkout emacs-25; git pull; make maintainer-clean; make clean; ./autogen.sh; ./configure --with-ns --without-x --with-gnutls --with-imagemagick --with-xml2 --with-rsvg --disable-ns-self-contained --with-modules --with-xwidgets; make -j2; make install;"

# use vim binding
bindkey -v

# insert mode binding
bindkey -M viins '^y' push-line
bindkey -M viins '^j' vi-cmd-mode
bindkey -M viins '^m' do_enter
bindkey -M viins '^o' fcdr
# bindkey -M viins '^o' fd
bindkey -M viins '^p' fdr
bindkey -M viins '^k' kill-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^f' forward-word
bindkey -M viins '^b' backward-word
bindkey -M viins '^r' fzf-history-widget

# normal mode binding
bindkey -M vicmd 'H' run-help
bindkey -M vicmd '^o' fcdr
# bindkey -M vicmd '^o' fd
bindkey -M vicmd '^p' fdr
bindkey -M vicmd '^k' fzf-cd-widget
bindkey -M vicmd '^r' fzf-history-widget

# text object
autoload -Uz select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done

autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N change-surround surround
zle -N add-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# visual mode
source ~/dotfiles/zsh-vimode-visual/zsh-vimode-visual.sh
bindkey -M vicmd 'v'  vi-visual-mode

# # fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# for mosh
compdef mosh=ssh
compdef sshrc=ssh

setopt nonomatch
alias du-cwd='du -mc -d 1 | sort -g'
alias reload='source ~/.zshrc'
alias gitf='git-flow'

add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

## tmux自動起動
# http://d.hatena.ne.jp/tyru/20100828/run_tmux_or_screen_at_shell_startup
# is_screen_running() {
#   # tscreen also uses this varariable.
#   [ ! -z "$WINDOW" ]
# }
# is_tmux_runnning() {
#   [ ! -z "$TMUX" ]
# }
# is_screen_or_tmux_running() {
#   is_screen_running || is_tmux_runnning
# }
# shell_has_started_interactively() {
#   [ ! -z "$PS1" ]
# }
# resolve_alias() {
#   cmd="$1"
#   while \
#     whence "$cmd" >/dev/null 2>/dev/null \
#     && [ "$(whence "$cmd")" != "$cmd" ]
# do
#   cmd=$(whence "$cmd")
# done
# echo "$cmd"
# }

# if ! is_screen_or_tmux_running && shell_has_started_interactively; then
#   for cmd in tmux; do
#     if whence $cmd >/dev/null 2>/dev/null; then
#       $(resolve_alias "$cmd")
#       break
#     fi
#   done
# fi

# cdd
chpwd() {
    _cdd_chpwd
}

if (which zprof > /dev/null) ;then
    zprof | less
fi

# The next line updates PATH for the Google Cloud SDK.
source '/Users/yuyaminami/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/yuyaminami/google-cloud-sdk/completion.zsh.inc'

tmuxx
