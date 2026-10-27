{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
    self.homeModules.extra
  ];

  nix-os-config.stateVersion = "25.11";
}
