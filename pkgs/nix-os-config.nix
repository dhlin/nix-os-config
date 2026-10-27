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

    # Pass the extra modules ENV sudo commands
    extra="''${NIX_OS_CONFIG_EXTRA_MODULES:-}"
  ''
  + lib.optionalString stdenv.isDarwin ''
    sudo env NIX_OS_CONFIG_EXTRA_MODULES="$extra" ${darwin-rebuild}/bin/darwin-rebuild switch "$@"
  ''
  + lib.optionalString stdenv.isLinux ''
    if [ -e /etc/NIXOS ]; then
      sudo env NIX_OS_CONFIG_EXTRA_MODULES="$extra" ${nixos-rebuild}/bin/nixos-rebuild switch "$@"
    else
      ${home-manager}/bin/home-manager switch "$@"
    fi
  '')
