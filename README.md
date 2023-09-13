# nix-os-config

## Install
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
```
## Home standalone
```
nix --extra-experimental-features "nix-command flakes" build --impure .#homeConfigurations.home.activationPackage
./result/activate
```

## Darwin
```
nix --extra-experimental-features "nix-command flakes" build --impure .#darwinConfigurations.darwin.system
./result/sw/bin/darwin-rebuild switch --impure --flake .#darwin
```
