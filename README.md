# nix-os-config

## Install
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
nix --extra-experimental-features "nix-command flakes" build --impure .#homeConfigurations.home.activationPackage
./result/activate
```
