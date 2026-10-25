{
  config,
  lib,
  pkgs,
  ...
}: let
  envUser = import ../../lib/env-user.nix;
  inherit (config.users) primaryUser;
in {
  options.users.primaryUser = lib.mkOption {
    type = lib.types.str;
    default = envUser;
    defaultText = lib.literalExpression ''builtins.getEnv "SUDO_USER", or "USER"'';
    description = "Login name of the machine's main interactive user.";
  };

  config = {
    users.users.${primaryUser} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };

    nix.settings.trusted-users = ["root" primaryUser];
  };
}
