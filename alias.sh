# docker
alias de='docker exec -it'
alias dep='de --privileged'
alias di='docker images'
alias dirm='docker image rm'
alias dp='docker ps'
alias dpa='docker ps -a'
alias dr='docker run -it --rm'
alias drm='docker rm'
alias drp='dr --privileged'

# git
alias gb='git branch'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gfo='git fetch origin' 
alias gp='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gs='git status'

#
alias ll='ls -laG'
