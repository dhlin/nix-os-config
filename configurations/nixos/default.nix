{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.disk
    self.nixosModules.extra
    self.nixosModules.hardware
  ];

  nix-os-config = {
    stateVersion = "25.11";
    homeStateVersion = "25.11";
  };

  nix-os-config.primaryUser = "dhlin";
}
