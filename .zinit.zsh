zinit ice depth"1"
zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-autosuggestions

if which -s fzf > /dev/null; then
    zinit snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
fi
