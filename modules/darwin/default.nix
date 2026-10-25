{
  config,
  lib,
  ...
}: {
  imports = [
    ../common
  ];

  system.primaryUser = lib.mkDefault config.nix-os-config.primaryUser;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
}
