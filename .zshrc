source $ZDOTDIR/zinit/zinit.zsh

source $ZDOTDIR/.zinit.zsh

source $ZDOTDIR/.p10k.zsh

bindkey \^U backward-kill-line

export TERM=xterm-256color

source $ZDOTDIR/alias.sh

export HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
