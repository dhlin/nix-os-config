#!/usr/bin/env bash

set -euo pipefail

# An optional leading configuration name, then flags for nixos-install. Matches
# how `nix run` activates a configuration:
#
#   nix run .#install              # nixosConfigurations.default
#   nix run .#install -- laptop    # nixosConfigurations.laptop
name=default
case "${1:-}" in
  "" | -*) ;;
  *)
    name="$1"
    shift
    ;;
esac

[ "$(id -u)" = 0 ] || {
  echo "install: run as root" >&2
  exit 1
}

# passwd at the end needs a terminal. Check now, before the disk is wiped.
[ -r /dev/tty ] || {
  echo "install: no terminal; passwd needs one to set the login password" >&2
  exit 1
}

mkdir -p /etc/nixos
nixos-generate-config --no-filesystems --show-hardware-config \
  > /etc/nixos/hardware-configuration.nix

user=$(nix --extra-experimental-features "nix-command flakes" eval --impure --raw \
  ".#nixosConfigurations.$name.config.nix-os-config.primaryUser")

@disko@ --impure --mode destroy,format,mount --flake ".#$name"

mkdir -p /mnt/etc/nixos
cp /etc/nixos/hardware-configuration.nix /mnt/etc/nixos/

nixos-install --impure --no-root-passwd --flake ".#$name" "$@"

# copy the configuration for the primary user to use after installation
mkdir -p "/mnt/home/$user"
cp -rT . "/mnt/home/$user/nix-os-config"

nixos-enter --silent --root /mnt -- chown -R "$user:users" "/home/$user/nix-os-config"

echo "install: set the login password for '$user' (root stays locked)"
nixos-enter --silent --root /mnt -- passwd "$user"
