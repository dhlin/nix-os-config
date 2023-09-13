# nix-os-config

## Install
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
alias nix="nix --extra-experimental-features \"nix-command flakes\"" 
```
## Home standalone
```
nix build --impure .#homeConfigurations.home.activationPackage
./result/activate
```

## Darwin
```
nix build --impure .#darwinConfigurations.darwin.system
./result/sw/bin/darwin-rebuild switch --impure --flake .#darwin
```
