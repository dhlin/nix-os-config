{
  config,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.state
    self.nixosModules.user
    /etc/nixos/hardware-configuration.nix
  ];


  users.primaryUser = "dhlin";

  home-manager.users.${config.users.primaryUser}.imports = [../home/default.nix];
}
