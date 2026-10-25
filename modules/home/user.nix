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
