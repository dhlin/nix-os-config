# Nix daemon settings for NixOS and nix-darwin.
{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;

  # The GC schedule option differs per platform.
  gcSchedule =
    if isDarwin
    then {interval.Day = 7;}
    else {dates = "weekly";};
in {
  nix = {
    gc =
      {
        automatic = true;
        options = "--delete-older-than 7d";
      }
      // gcSchedule;

    optimise.automatic = true;
  };
}
