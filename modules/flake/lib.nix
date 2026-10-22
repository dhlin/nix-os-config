# This flake's `lib`: helpers another flake can reuse without copying them.
#
# `mkActivate` builds the 'nix run' activation script. Callers pass their own
# `pkgs` and `inputs'` so the rebuild commands come from their own
# nixpkgs/nix-darwin/home-manager, and their own configurations are what gets
# activated (the script always targets the flake in $PWD).
{lib, ...}: {
  flake.lib = {
    mkActivate = {
      pkgs,
      inputs',
    }:
      pkgs.writeShellScriptBin "nix-os-config" (''
        # Run via `nix run` from the clone you want to rebuild from: on a NixOS
        # install that is ~/nix-os-config, not the ISO clone the installer ran in.
        #
        #   nix run               # the "default" configuration
        #   nix run . -- laptop   # the configuration named "laptop"
        #   nix run . -- laptop --show-trace   # flags after the name go to the rebuild
        #
        # An optional leading configuration name, then flags for the rebuild.
        name=default
        case "''${1:-}" in
          "" | -*) ;;
          *)
            name="$1"
            shift
            ;;
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
