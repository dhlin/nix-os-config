# The 'nix run' activation script.
#
# Kept out of packages/ so autowiring does not callPackage it with no arguments.
#
# The script always activates the flake in $PWD, so a downstream repo activates
# its own configurations.
{
  lib,
  stdenv,
  writeShellScriptBin,
  nixos-rebuild,
  home-manager,
  darwin-rebuild,
}:
writeShellScriptBin "nix-os-config" (''
    # Usage:
    #   nix run                            # the "default" configuration
    #   nix run . -- laptop                # the configuration named "laptop"
    #   nix run . -- laptop --show-trace   # flags after the name go to the rebuild

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
  + lib.optionalString stdenv.isDarwin ''
    sudo ${darwin-rebuild}/bin/darwin-rebuild switch "$@"
  ''
  + lib.optionalString stdenv.isLinux ''
    if [ -e /etc/NIXOS ]; then
      sudo ${nixos-rebuild}/bin/nixos-rebuild switch "$@"
    else
      ${home-manager}/bin/home-manager switch "$@"
    fi
  '')
