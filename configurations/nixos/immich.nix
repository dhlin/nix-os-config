{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    ./default.nix
    self.nixosModules.immich
  ];

  nix-os-config = {
    stateVersion = "25.11";
    homeStateVersion = "25.11";
  };
}
