# zmodload zsh/zprof && zprof

#for prezto
# Ensure that a non-login, non-interactive shell has a defined environment.

if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

if [ -e ${HOME}/.cabel/bin ]; then
  export PATH=${HOME}/.cabal/bin:${PATH}
fi

if [ -e ${HOME}/go ]; then
  export GOPATH=$HOME/go
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi

if [ -d ${HOME}/.rbenv ] ; then
  PATH=${HOME}/.rbenv/bin:${PATH}
  export PATH
  eval "$(rbenv init -)"
fi

if [ -d /usr/local/opt/coreutils/libexec/gnubin ] ; then
  export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
  export MANPATH=/usr/local/opt/coreutils/libexec/gnuman/:$MANPATH
fi

export EDITOR='vim'
export SYS_NOTIFIER=`which terminal-notifier`
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
export LANG=ja_JP.utf8
export PAGER='less'
export LESS='-g -n -i -M -R -S -w -X -z4'
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

if [ -e ${HOME}/.my_zshenv ]; then
  source ${HOME}/.my_zshenv
fi
