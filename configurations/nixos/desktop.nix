{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    ./default.nix
    self.nixosModules.desktop
  ];
}
