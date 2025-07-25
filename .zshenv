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

export ZPLUG_HOME=$HOME/zplug
export EDITOR=emacsclient
# export EDITOR='emacsclient -n'
# export EDITOR=vim
export LANG="ja_JP.UTF-8"

export PATH=/usr/local/bin:${PATH}
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$HOME/local/bin:$PATH

case ${OSTYPE} in
    darwin*)
        if which terminal-notifier > /dev/null; then
            export SYS_NOTIFIER=`which terminal-notifier`
        fi

        export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
        # export PATH=/usr/local/opt/texinfo/bin:$PATH

        # if /usr/libexec/java_home > /dev/null 2> /dev/null; then
        #     export JAVA_HOME=`/usr/libexec/java_home`
        #     export PATH=$PATH:$JAVA_HOME/bin
        # fi

        # export HOMEBREW_NO_ANALYTICS=1
        # export HOMEBREW_CASK_OPTS='--appdir=/Applications'
        # export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
        export TERM='xterm-256color'
        # export PATH="/usr/local/opt/llvm/bin:$PATH"
        # export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

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

if [ -e ${HOME}/.cargo/env ]; then
    . "$HOME/.cargo/env"
fi

if [ -d "/Users/yuya373/Library/pnpm" ]; then
    export PNPM_HOME="/Users/yuya373/Library/pnpm"
    export PATH="$PNPM_HOME:$PATH" ;
fi

eval "$(direnv hook zsh)"

# OPAM configuration
. /home/yuya373/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

if (which nodenv > /dev/null) ;then
   eval "$(nodenv init - zsh)"
fi

if [ -d ${HOME}/.rbenv/bin ]; then
    export PATH=${HOME}/.rbenv/bin:${PATH}
fi

if (which rbenv > /dev/null) ;then
   eval "$(rbenv init -)"
fi

if (which anyenv > /dev/null) ;then
   eval "$(anyenv init -)"
fi

if [ -d ${HOME}/.goenv ]; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
  export PATH="$GOROOT/bin:$PATH"
  export PATH="$PATH:$GOPATH/bin"
fi

if [ -d ${HOME}/.npm-global ]; then
    export PATH=~/.npm-global/bin:$PATH
fi

if [ -e ${HOME}/.local/bin/env ]; then
    source $HOME/.local/bin/env
fi
