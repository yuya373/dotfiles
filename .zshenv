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

export EDITOR='vim'
export SYS_NOTIFIER=`which terminal-notifier`
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
export LANG=ja_JP.UTF-8
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

if [ -e ${HOME}/.my_zshenv ]; then
  source ${HOME}/.my_zshenv
fi
