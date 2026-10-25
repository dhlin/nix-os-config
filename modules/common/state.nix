{
  config,
  lib,
  ...
}: {
  options.nix-os-config = {
    stateVersion = lib.mkOption {
      # `system.stateVersion` is a string on NixOS and an integer on nix-darwin;
      # that option's own type does the strict check.
      type = lib.types.either lib.types.str lib.types.int;
      example = "25.11";
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

    home-manager.users.${config.nix-os-config.primaryUser} = {
      nix-os-config.stateVersion = config.nix-os-config.homeStateVersion;
    };
  };
}
