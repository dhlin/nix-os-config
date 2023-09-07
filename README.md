# nix-os-config

## Install
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
home-manager -f home.nix switch
```
