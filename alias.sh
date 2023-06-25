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
alias gau='git add -u'
alias gb='git branch'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gfo='git fetch origin'
alias gl='git log'
alias grs='git restore --staged'
alias grv='git remote -vv'
alias gp='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gs='git status'

# misc
alias ll='ls -laG'
alias s='source'
