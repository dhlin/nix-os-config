# The flake-parts module every consumer of this repo gets.
#
# Consumed two ways:
#   - auto-imported by nixos-unified.lib.mkFlake, for this repo's own
#     configurations (like ./lib.nix, which exports `lib` and `flakeModules`)
#   - lib.mkFlake / flakeModules.default, for downstream flakes
#
# Everything here is defined in terms of the *consuming* flake's `inputs`, so a
# downstream flake that overrides an input gets a package set and an
# activation script built from its own pin.
#
# It expects `inputs.nixpkgs` and `inputs.nixos-unified` to be present;
# lib.mkFlake injects both, so a downstream flake needs neither as an input.
{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];

  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: {
    # The `pkgs` every perSystem definition sees.
    #
    # Set explicitly because flake-parts' default reads `inputs'.nixpkgs`, and
    # `inputs'` is built from `self.inputs`: under lib.mkFlake that is only what
    # the downstream flake.nix declares, which need not include nixpkgs.
    _module.args.pkgs = inputs.nixpkgs.legacyPackages.${system};

    formatter = pkgs.alejandra;

    packages = {
      nix-os-config = pkgs.callPackage ../../pkgs/nix-os-config.nix {
        inherit (inputs.nix-darwin.packages.${system}) darwin-rebuild;
        inherit (inputs.home-manager.packages.${system}) home-manager;
      };
      # use mkDefault, otherwise this repo's own autowired definition would conflict
      # with these ones.
      install = lib.mkDefault inputs.nix-os-config.packages.${system}.install;
      default = lib.mkDefault config.packages.nix-os-config;
    };
  };
}
