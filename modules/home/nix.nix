{
  config,
  pkgs,
  lib,
  ...
}:
# Only applies to the standalone home-manager configuration
lib.mkIf (!config.submoduleSupport.enable) {
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
  };
}
