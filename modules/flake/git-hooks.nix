# Pre-commit hooks for the development.
# Run `nix develop` will install the hook.
{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      statix.enable = true;
      deadnix.enable = true;
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [config.pre-commit.devShell];
    };
  };
}
