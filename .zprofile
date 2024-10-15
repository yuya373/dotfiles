case ${OSTYPE} in
    darwin*)
	eval "$(/opt/homebrew/bin/brew shellenv)"
        source ~/.zshenv
        ;;
esac
