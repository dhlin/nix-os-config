{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.darwinModules.default
    self.darwinModules.extra
  ];

  nix-os-config = {
    stateVersion = 5;
    homeStateVersion = "25.11";
  };
}
