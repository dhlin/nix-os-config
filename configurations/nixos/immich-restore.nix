{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    ./default.nix
    self.nixosModules.immich-restore
  ];

  networking.hostName = "immich-restore";

  nix-os-config = {
    stateVersion = "25.11";
    homeStateVersion = "25.11";
  };
}
