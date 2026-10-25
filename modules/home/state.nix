{
  config,
  lib,
  ...
}: {
  options.nix-os-config.stateVersion = lib.mkOption {
    type = lib.types.str;
    example = "25.11";
    description = "Value for `home.stateVersion`. Required; has no default.";
  };

  config.home.stateVersion = config.nix-os-config.stateVersion;
}
