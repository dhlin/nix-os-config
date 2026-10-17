{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
  # Get the invoking user if running under sudo, otherwise fall back to the current user.
  sudoUser = builtins.getEnv "SUDO_USER";
  username =
    if sudoUser != ""
    then sudoUser
    else builtins.getEnv "USER";
in {
  imports = [
    self.darwinModules.default
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = "darwin";

  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  home-manager.users.${username}.imports = [../home/default.nix];

  nix.settings.trusted-users = ["root" username];

  system.stateVersion = 5;
}
