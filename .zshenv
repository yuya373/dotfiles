if [ -d ${HOME}/.rbenv ] ; then
  PATH=${HOME}/.rbenv/bin:${PATH}
  export PATH
  eval "$(rbenv init -)"
fi

export TMUX_POWERLINE_SEG_WEATHER_LOCATION="26237038"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export LANG=ja_JP.UTF-8
source ~/dotfiles/.tmux-powerlinerc.default
