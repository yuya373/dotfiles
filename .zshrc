
if [ ! -d $HOME/.zfunctions ]; then
    echo "creating $HOME/.zfunctions ..."
    mkdir -p $HOME/.zfunctions
fi
fpath=("$HOME/.zfunctions" $fpath)

# zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", nice:19
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

zplug "zsh-users/zsh-history-substring-search"
zplug "sindresorhus/pure", ignore:"*.zsh", \
      hook-load: "{
ln -sf $ZPLUG_HOME/repos/sindresorhus/pure/pure.zsh $HOME/.zfunctions/prompt_pure_setup
ln -sf $ZPLUG_HOME/repos/sindresorhus/pure/async.zsh $HOME/.zfunctions/async
}"
zplug "seebi/dircolors-solarized"

zplug "zsh-users/zsh-completions", \
      hook-load: "fpath=("$ZPLUG_REPOS/zsh-users/zsh-completions" $fpath)"
zplug "zsh-users/zsh-autosuggestions"

zplug "b4b4r07/dotfiles", use:etc/lib/vital.sh, \
          hook-load: ""
zplug "b4b4r07/dotfiles", use:bin/tmuxx, as:command
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-vimode-visual"

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "junegunn/fzf", use:"shell/*.zsh"

zplug "sorin-ionescu/prezto", \
      use:"modules/{completion,directory,history,rsync}/*.zsh"
# zplug "sorin-ionescu/prezto", \
    #       as:command, \
    #       use:"modules/archive/functions/*"

zplug "arks22/tmuximum", as:command

# Then, source plugins and add commands to $PATH
zplug load # --verbose

source ~/dotfiles/.zenv
source ~/dotfiles/.zprompt
source ~/dotfiles/.zshfunc
source ~/dotfiles/.zsh_keybind
source ~/dotfiles/.zsh_aliases

# autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=136'
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(do_enter kill-line $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)

# dircolors
eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Customize to your needs...
setopt NO_BEEP
setopt nonomatch

# autoload -Uz run-help
# autoload -Uz run-help-git

#for brew-file
if [ -f $(brew --prefix)/etc/brew-wrap ];then
    source $(brew --prefix)/etc/brew-wrap
fi

# tmuxx

if (which zprof > /dev/null) ;then
    zprof | less
fi
