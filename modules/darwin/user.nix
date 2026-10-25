{
  config,
  lib,
  pkgs,
  ...
}: let
  envUser = import ../../lib/env-user.nix;
  inherit (config.system) primaryUser;
in {
  system.primaryUser = lib.mkDefault envUser;

  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = lib.mkDefault pkgs.zsh;
  };

  nix.settings.trusted-users = ["root" primaryUser];
}
