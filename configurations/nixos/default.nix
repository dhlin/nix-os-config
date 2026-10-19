{
  config,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.disko.nixosModules.disko
    self.nixosModules.default
    self.nixosModules.disk
    self.nixosModules.state
    self.nixosModules.user
    /etc/nixos/hardware-configuration.nix
  ];

  users.primaryUser = "dhlin";

  home-manager.users.${config.users.primaryUser}.imports = [../home/default.nix];
}
