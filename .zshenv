# zmodload zsh/zprof && zprof

#for prezto
# Ensure that a non-login, non-interactive shell has a defined environment.

if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

if [ -e ${HOME}/.cabal/bin ]; then
  export PATH=${HOME}/.cabal/bin:${PATH}
fi

if [ -e /usr/local/opt/go ]; then
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$PATH:/usr/local/opt/go/libexec/bin:${HOME}/go/bin
fi

if [ -d ${HOME}/.rbenv ] ; then
  PATH=${HOME}/.rbenv/bin:${PATH}
  export PATH
  eval "$(rbenv init -)"
fi

if [ -d ${HOME}/.roswell ]; then
    PATH=${HOME}/.roswell/bin:${PATH}
    export PATH
fi

if [ -d /usr/local/opt/coreutils/libexec/gnubin ] ; then
  export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
  export MANPATH=/usr/local/opt/coreutils/libexec/gnuman/:$MANPATH
fi

export EDITOR='vim'
export EDITOR='emacsclient -n -a emacs'
export SYS_NOTIFIER=`which terminal-notifier`
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
export LANG=ja_JP.utf8
export PAGER='less'
export LESS='-g -n -i -M -R -S -w -X -z4'
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

if [ -e ${HOME}/.my_zshenv ]; then
  source ${HOME}/.my_zshenv
fi

if which pyenv > /dev/null; then
  PATH=/usr/local/opt/pyenv/shims:${PATH}
  export PATH
fi
