# zmodload zsh/zprof && zprof

# Ensure that a non-login, non-interactive shell has a defined environment.

export ZPLUG_HOME=/usr/local/opt/zplug

export PATH=/usr/local/bin:${PATH}

# if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#     source "${ZDOTDIR:-$HOME}/.zprofile"
# fi

if [ -e ${HOME}/.cargo/bin ]; then
    export PATH=${HOME}/.cargo/bin:${PATH}
    export RUST_SRC_PATH=${HOME}/rustc-1.5.0/src
fi

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

if [ -d $HOME/.multirust/toolchains/stable/cargo/bin ]; then
    export PATH=$HOME/.multirust/toolchains/stable/cargo/bin:$PATH
fi


# export EDITOR='vim'
export SYS_NOTIFIER=`which terminal-notifier`
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
export PAGER='less'
# export LESS='-g -n -i -M -R -S -w -X -z4'
export LESS='-g -n -i -M -R -w -X -z4'
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

if [ -e ${HOME}/.my_zshenv ]; then
    source ${HOME}/.my_zshenv
fi

if which pyenv > /dev/null; then
    PATH=/usr/local/opt/pyenv/shims:${PATH}
    export PATH
fi

export EDITOR='emacsclient -n'
export JAVA_HOME=`/usr/libexec/java_home`
export PATH=$PATH:$JAVA_HOME/bin
export MANPATH=/usr/local/share/man/ja_JP.UTF-8:$MANPATH
export HOMEBREW_NO_ANALYTICS=1
export LANG="ja_JP.UTF-8"
export PATH=$HOME/.nodebrew/current/bin:$PATH

# autoload -Uz compinit
# compinit
