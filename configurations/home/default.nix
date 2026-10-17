{
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
  ];

  home = {
    # mkDefault so a system config (nix-darwin/NixOS) can forward its own
    # username; this value only applies to the standalone activation.
    username = lib.mkDefault (builtins.getEnv "USER");
    stateVersion = "25.11";
  };
}
