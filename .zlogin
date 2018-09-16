[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
