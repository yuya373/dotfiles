
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"
# ZSH_THEME="default"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="sunrise"
# ZSH_THEME="original"


# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=()

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH="/usr/local/bin:~/.rbenv/bin:~/.cabal/bin:$PATH"

eval "$(rbenv init - zsh)"



# alias less="less -R"
alias g="git"
alias be="bundle exec"
alias spacee="ssh spacee@ec2-54-249-19-113.ap-northeast-1.compute.amazonaws.com"
alias ygem="yard server --gems"
alias railss='bundle exec spring rails s'
alias railsc='bundle exec spring rails c'
alias railsr='bundle exec spring rails runner'
alias raker='bundle exec spring rake routes'
alias migrate='bundle exec spring rake db:migrate'
export LANG=ja_JP.UTF-8
# export LESSCHARSET=utf-8
# [[ -z "$TMUX" && ! -z "$PS1" ]] && tmux
