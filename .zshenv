# zmodload zsh/zprof && zprof
case ${OSTYPE} in
    darwin*)
        export SYS_NOTIFIER=`which terminal-notifier`
        export HOMEBREW_CASK_OPTS='--appdir=/Applications'
        export ZPLUG_HOME=/usr/local/opt/zplug
        export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
        export JAVA_HOME=`/usr/libexec/java_home`
        export PATH=$PATH:$JAVA_HOME/bin
        export MANPATH=/usr/local/share/man/ja_JP.UTF-8:$MANPATH
        export HOMEBREW_NO_ANALYTICS=1
        export TERM='xterm-256color'
        export SBT_OPTS="-Xms512m -Xmx512m -XX:ReservedCodeCacheSize=128m -XX:MaxMetaspaceSize=256m"
        export PATH="/usr/local/opt/llvm/bin:$PATH"
        ;;
    linux*)
        export PATH=/usr/local/bin:${PATH}
        setopt no_global_rcs
        export ZPLUG_HOME=$HOME/zplug
        ;;
esac


# Ensure that a non-login, non-interactive shell has a defined environment.

export PATH=/usr/local/bin:${PATH}

# if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#     source "${ZDOTDIR:-$HOME}/.zprofile"
# fi

if [ -e ${HOME}/.cabal/bin ]; then
    export PATH=${HOME}/.cabal/bin:${PATH}
fi

if [ -e /usr/local/opt/go ]; then
    if [ ! -d $HOME/go ]; then
        mkdir -p $HOME/go
    fi
    export PATH=$PATH:/usr/local/opt/go/libexec/bin:${HOME}/go/bin
    export GOPATH=$HOME/go
fi

if [ -d ${HOME}/.rbenv ] ; then
    export PATH=${HOME}/.rbenv/bin:${PATH}
fi

if [ -d ${HOME}/.roswell ]; then
    export PATH=${HOME}/.roswell/bin:${PATH}
fi

export PAGER='less'
# export LESS='-g -n -i -M -R -S -w -X -z4'
export LESS='-g -n -i -M -R -w -X -z4'

if [ -e ${HOME}/.my_zshenv ]; then
    source ${HOME}/.my_zshenv
fi

if which pyenv > /dev/null; then
    PATH=/usr/local/opt/pyenv/shims:${PATH}
    export PATH
fi

export EDITOR='emacsclient -n'
export EDITOR=vim
export LANG="ja_JP.UTF-8"
export PATH=$HOME/.nodebrew/current/bin:$PATH
export NODE_BINARY=$HOME/.nodebrew/current/bin/node
export PATH=$HOME/.local/bin:$PATH

export PATH="$HOME/.cargo/bin:$PATH"
export WEBPACK_NOTIFY=true
