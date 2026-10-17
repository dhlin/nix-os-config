{inputs, ...}: {
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem = {
    inputs',
    lib,
    pkgs,
    ...
  }: {
    formatter = pkgs.alejandra;

    packages.default = pkgs.writeShellScriptBin "nix-os-config" (''
        # An optional leading configuration name, then flags for the rebuild.
        name=default
        case "''${1:-}" in
          "" | -*) ;;
          *) name="$1"; shift ;;
        esac
        # Evaluating the configurations reads $USER / $SUDO_USER, so --impure is
        # always on; any further arguments go to the rebuild command as given.
        set -- --impure --flake ".#$name" "$@"
      ''
      + lib.optionalString pkgs.stdenv.isDarwin ''
        sudo ${inputs'.nix-darwin.packages.darwin-rebuild}/bin/darwin-rebuild switch "$@"
      ''
      + lib.optionalString pkgs.stdenv.isLinux ''
        if [ -e /etc/NIXOS ]; then
          sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch "$@"
        else
          ${inputs'.home-manager.packages.home-manager}/bin/home-manager switch "$@"
        fi
      '');
  };
}
