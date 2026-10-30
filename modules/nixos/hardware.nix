{lib, ...}: let
  hardware = /etc/nixos/hardware-configuration.nix;
in {
  imports = lib.optional (builtins.pathExists hardware) hardware;
}
