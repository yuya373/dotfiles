start() {
    if [[ ! -n $TMUX ]]; then
        # get the IDs
        ID="`tmux list-sessions`"
        if [[ -z "$ID" ]]; then
            tmux new-session
        fi
        create_new_session="Create New Session"
        ID="$ID\n${create_new_session}:"
        ID="`echo $ID | fzf | cut -d: -f1`"
        if [[ "$ID" = "${create_new_session}" ]]; then
            tmux new-session
        elif [[ -n "$ID" ]]; then
            tmux attach-session -t "$ID"
        else
            :  # Start terminal normally
        fi
    fi
}
case $OSTYPE in
    linux*)
        if [[ $DISPLAY ]]; then
            start
        fi
        ;;
    darwin*)
        start
        ;;
esac
