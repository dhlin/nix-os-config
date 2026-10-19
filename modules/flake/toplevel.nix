{inputs, ...}: {
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
    ./lib.nix
    ./pkgs.nix
  ];
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    formatter = pkgs.alejandra;

    # packages/ is autowired by nixos-unified: `callPackage fn {}` per .nix file
    # and per directory holding a default.nix. packages/install therefore needs
    # no wiring here; its `disko` dependency comes from ./pkgs.nix.
    packages = {
      # 'nix run' activates the configuration for the current OS.
      default = inputs.self.lib.mkActivate {inherit pkgs inputs';};
    };
  };
}
