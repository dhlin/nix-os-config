{
  config,
  lib,
  ...
}: {
  imports = [
    ./state.nix
    ./user.nix
  ];

  home-manager.users.${config.system.primaryUser}.imports = [../home/default.nix];

  services = {
    tailscale.enable = true;
  };

  programs.zsh.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
  };
}
