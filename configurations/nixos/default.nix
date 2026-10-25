{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
  hardware = /etc/nixos/hardware-configuration.nix;
in {
  imports =
    [
      self.nixosModules.default
      self.nixosModules.disk
    ]
    ++ lib.optional (builtins.pathExists hardware) hardware;

  nix-os-config = {
    stateVersion = "25.11";
    homeStateVersion = "25.11";
  };

  nix-os-config.primaryUser = "dhlin";
}
