# The primary user of a NixOS machine.
# Autowired to `nixosModules.user`.
#
# NixOS has no equivalent of nix-darwin's `system.primaryUser`, so this module
# declares one. It defaults to $SUDO_USER, falling back to $USER; a
# configuration that sets it itself outranks the default, so the getEnv calls
# are never forced and the configuration evaluates without --impure.
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
      # Plain assignment: NixOS already defines a mkDefault shell per user
      # (from users.defaultUserShell), so a second mkDefault would conflict.
      shell = pkgs.zsh;
    };

    nix.settings.trusted-users = ["root" primaryUser];
  };
}
