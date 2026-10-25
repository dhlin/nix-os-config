# Settings shared by the NixOS and nix-darwin system modules.
{config, ...}: {
  imports = [
    ./nix.nix
    ./user.nix
    ./state.nix
  ];

  home-manager.users.${config.nix-os-config.primaryUser}.imports = [../home/default.nix];

  programs.zsh.enable = true;

  services.tailscale.enable = true;
}
