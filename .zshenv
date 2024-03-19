# zmodload zsh/zprof && zprof


export PAGER='less'
# export LESS='-g -n -i -M -R -S -w -X -z4'
export LESS='-g -n -i -M -R -w -X -z4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
# export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export GOPATH=$HOME/go
export ZPLUG_HOME=$HOME/zplug
export EDITOR='emacsclient -n'
export EDITOR=vim
export LANG="ja_JP.UTF-8"

export PATH=/usr/local/bin:${PATH}
export PATH="$HOME/.cargo/bin:$PATH"
mkdir -p $HOME/go/bin
export PATH=$PATH:${GOPATH}/bin
export PATH=$HOME/local/bin:$PATH

case ${OSTYPE} in
    darwin*)
        if which terminal-notifier > /dev/null; then
            export SYS_NOTIFIER=`which terminal-notifier`
        fi

        export PATH=/usr/local/opt/texinfo/bin:$PATH

        if /usr/libexec/java_home > /dev/null 2> /dev/null; then
            export JAVA_HOME=`/usr/libexec/java_home`
            export PATH=$PATH:$JAVA_HOME/bin
        fi

        export HOMEBREW_NO_ANALYTICS=1
        export HOMEBREW_CASK_OPTS='--appdir=/Applications'
        export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
        export TERM='xterm-256color'
        # export PATH="/usr/local/opt/llvm/bin:$PATH"
        export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

        if [ -d /Applications/Genymotion.app/Contents/MacOS/tools ] ; then
            export PATH=$PATH:/Applications/Genymotion.app/Contents/MacOS/tools
        fi
        ;;
    linux*)
        setopt no_global_rcs
        ;;
esac

# Ensure that a non-login, non-interactive shell has a defined environment.


# if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#     source "${ZDOTDIR:-$HOME}/.zprofile"
# fi

if [ -e ${HOME}/.cabal/bin ]; then
    export PATH=${HOME}/.cabal/bin:${PATH}
fi

if [ -d ${HOME}/.roswell ]; then
    export PATH=${HOME}/.roswell/bin:${PATH}
fi

if [ -d ${HOME}/.yarn/bin ]; then
    export PATH=${HOME}/.yarn/bin:${PATH}
fi

if [ -e ${HOME}/.my_zshenv ]; then
    source ${HOME}/.my_zshenv
fi

source ~/dotfiles/.zenv
. "$HOME/.cargo/env"
