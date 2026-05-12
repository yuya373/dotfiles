#
# ~/.bashrc
#

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
  if [[ -n ${EMACS_VTERM_PATH} ]]; then
    if [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh ]]; then
      source ${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh
    fi
  fi
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

. "$HOME/.local/bin/env"

# claudeコマンドをmise管理のNode.jsで実行する関数
claude() {
    command claude "$@"
}

. "$HOME/.moon/bin/env"

eval "$(mise activate bash)"
