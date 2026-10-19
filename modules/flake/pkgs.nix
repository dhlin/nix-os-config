# The `pkgs` every perSystem definition sees.
#
# Autowiring turns overlays/*.nix into `overlays.<name>` outputs but applies
# them nowhere, so apply all of them here. That is what lets an autowired
# packages/* resolve an overridden dependency through callPackage.
#
# Instantiated with the overlays in one go rather than `legacyPackages.extend`:
# extend re-runs the whole package-set fixpoint, so it would evaluate nixpkgs a
# second time. Overlays compose in attribute-name order.
{inputs, ...}: {
  perSystem = {
    lib,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = lib.attrValues inputs.self.overlays;
    };
  };
}
