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

    # Link $NIX_OS_CONFIG_EXTRA_MODULES to the default location for later runs
    if [ -n "''${NIX_OS_CONFIG_EXTRA_MODULES:-}" ]; then
      extra=$(cd "$NIX_OS_CONFIG_EXTRA_MODULES" && pwd -P) || exit 1
      link="$HOME/.config/nix-os-config/modules"
      if [ -d "$link" ] && [ ! -L "$link" ]; then
        echo "nix-os-config: $link is a directory; move it away to link $extra" >&2
        exit 1
      fi
      mkdir -p "$(dirname "$link")"
      ln -sfn "$extra" "$link"
      export NIX_OS_CONFIG_EXTRA_MODULES="$extra"
    fi
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
