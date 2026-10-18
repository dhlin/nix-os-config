# The user a standalone home-manager configuration belongs to.
# Autowired to `homeModules.user`.
#
# Same deal as `darwinModules.user`: the name defaults to $SUDO_USER, falling
# back to $USER, and the home directory follows from it. Those defaults are the
# only impure part, and a configuration that sets `home.username` itself
# outranks them, so the getEnv calls are never forced.
#
# Only applies to the standalone configuration -- under nix-darwin/NixOS the
# system layer passes the username in.
{
  config,
  lib,
  pkgs,
  ...
}: let
  envUser = import ../../lib/env-user.nix;
in
  lib.mkIf (!config.submoduleSupport.enable) {
    home = {
      username = lib.mkDefault envUser;
      homeDirectory = lib.mkDefault (
        if pkgs.stdenv.isDarwin
        then "/Users/${config.home.username}"
        else "/home/${config.home.username}"
      );
    };
  }
