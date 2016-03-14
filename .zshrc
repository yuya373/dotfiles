# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

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

# git-it-on
source ~/dotfiles/git-it-on.zsh/git-it-on.plugin.zsh

# disable keyboard
alias disablekeyboard="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias enablekeyboard="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"

# Gitit Aliases
alias compare="gitit compare"
alias commits="gitit commits"
alias branch="gitit branch"
alias gistory="gitit history"
alias prs="gitit pulls"
alias myprs="gitit pulls author:yuya373" #put your name here

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
bindkey -v '^Y' push-line
bindkey -v '^J' vi-cmd-mode
bindkey -v '^m' do_enter
bindkey -v '^@' fcdr
bindkey -v '^o' fd
bindkey -v '^p' fdr
bindkey -v '^k' fzf-cd-widget

# normal mode binding
bindkey -a 'H' run-help
bindkey -a '^@' fcdr
bindkey -a '^o' fd
bindkey -a '^p' fdr
bindkey -a '^k' fzf-cd-widget
bindkey -a '^r' fzf-history-widget


# from .zshfunc

# text object
autoload -U select-quoted
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
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

# visual mode
source ~/dotfiles/zsh-vimode-visual/zsh-vimode-visual.sh
bindkey -M vicmd 'v'  vi-visual-mode

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor line)
# source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fpath=(/usr/local/share/zsh-completions $fpath)
# fpath=(~/dotfiles/.zprezto/modules/completion/external/src $fpath)
# fpath=(/usr/local/share/zsh/site-functions $fpath)
# autoload -U compinit
# compinit -C

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

## For cdd
# http://blog.m4i.jp/entry/2012/01/26/064329
#
source ~/dotfiles/cdd/cdd

chpwd() {
  _cdd_chpwd
}

# PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

if (which zprof > /dev/null) ;then
  zprof | less
fi

# The next line updates PATH for the Google Cloud SDK.
source '/Users/yuyaminami/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/yuyaminami/google-cloud-sdk/completion.zsh.inc'
