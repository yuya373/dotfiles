#for prezto
# Ensure that a non-login, non-interactive shell has a defined environment.

if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

source ~/dotfiles/.tmux-powerlinerc.default

export PATH=/usr/local/bin:${PATH}

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

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export LANG=ja_JP.UTF-8
export EDITOR=vim
export LIB_CLANG_DIR=/Library/Developer/CommandLineTools/usr/lib
export MANPAGER="col -b -x|vim -R -c 'set ft=man nolist nomod noma' -"
