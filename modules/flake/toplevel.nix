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

    # 'nix run' activates the configuration for the current OS.
    packages.default = inputs.self.lib.mkActivate {inherit pkgs inputs';};
  };
}
