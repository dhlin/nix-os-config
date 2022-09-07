zinit ice depth"1"
zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-autosuggestions

zinit from"gh-r" \
    as"program" \
    for junegunn/fzf

zinit snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

zinit from"gh-r" \
    as"program" \
    atclone"./zoxide init zsh > zoxide.zsh" \
    atpull"%atclone" \
    pick"zoxide" src="zoxide.zsh" \
    for ajeetdsouza/zoxide
