# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_ROOT=/usr/local/opt/pyenv

# Customize to your needs...

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

# terminal-notifier
case "${OSTYPE}" in
  darwin*)
    source ~/dotfiles/zsh-notify/notify.plugin.zsh
    ;;
esac

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
alias gc="git chechout"
alias gcb="git checkout -b"
alias ga="git add"
alias gap="git add -p"
alias gp="git pull"
alias gcm="git commit"
alias gpu="git push"

# Emacs
alias ec="emacsclient -n"

# keybind
bindkey -v
bindkey -v '^Y' push-line
bindkey -v '^J' vi-cmd-mode


bindkey -a 'H' run-help
bindkey -a '^r' peco-select-history
bindkey -a '^@' peco-cdr
bindkey -a '^o' dev_pcd

# from .zshfunc
bindkey '^m' do_enter
bindkey '^r' peco-select-history
bindkey '^@' peco-cdr
bindkey '^v' peco-find-file
bindkey '^o' dev_pcd

#opp.zsh
source ~/dotfiles/opp.zsh/opp.zsh
source ~/dotfiles/opp.zsh/opp/*.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor line)
source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(~/dotfiles/.zprezto/modules/completion/external/src $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -C

# for mosh
compdef mosh=ssh

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
is_screen_running() {
  # tscreen also uses this varariable.
  [ ! -z "$WINDOW" ]
}
is_tmux_runnning() {
  [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
  is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
  [ ! -z "$PS1" ]
}
resolve_alias() {
  cmd="$1"
  while \
    whence "$cmd" >/dev/null 2>/dev/null \
    && [ "$(whence "$cmd")" != "$cmd" ]
do
  cmd=$(whence "$cmd")
done
echo "$cmd"
}

if ! is_screen_or_tmux_running && shell_has_started_interactively; then
  for cmd in tmux; do
    if whence $cmd >/dev/null 2>/dev/null; then
      $(resolve_alias "$cmd")
      break
    fi
  done
fi

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
