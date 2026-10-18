{
  config,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.darwinModules.default
    self.darwinModules.state
    self.darwinModules.user
  ];

  home-manager.users.${config.system.primaryUser}.imports = [../home/default.nix];
}
