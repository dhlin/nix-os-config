# nix-os-config

## Home standalone and Darwin
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
alias nix="nix --extra-experimental-features \"nix-command flakes\""
nix run
```

## NixOS

```
# boot from iso
sudo su
alias nix="nix --extra-experimental-features \"nix-command flakes\""
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
nix run .#install   # or: ... -- <configuration>
# ...installs, then prompts for the primary user's password
shutdown now
# remove iso, login as the primary user with the password you typed
# done, use `nix run` for rebuilding
```
