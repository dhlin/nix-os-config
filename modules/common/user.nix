{
  config,
  lib,
  pkgs,
  ...
}: let
  envUser = import ../../lib/env-user.nix;
  inherit (config.nix-os-config) primaryUser;
  inherit (pkgs.stdenv) isDarwin;
in {
  options.nix-os-config.primaryUser = lib.mkOption {
    type = lib.types.str;
    default = envUser;
    defaultText = lib.literalExpression ''builtins.getEnv "SUDO_USER", or "USER"'';
    description = "Login name of the machine's main interactive user.";
  };

  config = {
    nix.settings.trusted-users = ["root" primaryUser];

    users.users.${primaryUser} =
      if isDarwin
      then {
        home = "/Users/${primaryUser}";
        shell = pkgs.zsh;
      }
      else {
        isNormalUser = true;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
      };
  };
}
