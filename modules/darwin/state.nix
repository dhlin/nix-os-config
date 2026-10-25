{
  config,
  lib,
  ...
}: {
  options.nix-os-config = {
    stateVersion = lib.mkOption {
      type = lib.types.int;
      example = 5;
      description = "Value for `system.stateVersion`. Required; has no default.";
    };
    homeStateVersion = lib.mkOption {
      type = lib.types.str;
      example = "25.11";
      description = "Value for the primary user's `home.stateVersion`. Required; has no default.";
    };
  };

  config = {
    system.stateVersion = config.nix-os-config.stateVersion;

    home-manager.users.${config.system.primaryUser} = {
      nix-os-config.stateVersion = config.nix-os-config.homeStateVersion;
    };
  };
}
