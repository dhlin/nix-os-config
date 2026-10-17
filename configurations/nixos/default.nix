{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
  username = "dhlin";
in {
  imports = [
    self.nixosModules.default
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  home-manager.users.${username}.imports = [../home/default.nix];

  nix.settings.trusted-users = ["root" username];

  system.stateVersion = "25.11";
}
