#!/usr/bin/env bash
# Installs this flake onto a booted machine's disk: 'nix run --impure .#install'
# from a clone of the flake, as root, on a NixOS ISO.
#
# nixos-generate-config, nixos-install and nixos-enter come from the booted
# installer's PATH on purpose; pinning them from this flake's nixpkgs would
# install with a different version than the ISO was built from.
set -euo pipefail

# An optional leading configuration name, then flags for nixos-install. Matches
# how `nix run` activates a configuration:
#
#   nix run --impure .#install              # nixosConfigurations.default
#   nix run --impure .#install -- laptop    # nixosConfigurations.laptop
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
# The installer tools below come from the booted ISO, not from this flake, so
# bail out early where they would not exist rather than part-way through.
[ -e /etc/NIXOS ] || {
  echo "install: not running on NixOS; boot a NixOS ISO first" >&2
  exit 1
}
for cmd in nixos-generate-config nixos-install nixos-enter; do
  command -v "$cmd" >/dev/null || {
    echo "install: $cmd not on PATH; boot a NixOS installer ISO" >&2
    exit 1
  }
done
[ -e flake.nix ] || {
  echo "install: run from a clone of this flake" >&2
  exit 1
}
# The passwd call at the end of this script needs a terminal to prompt on.
# Checked here rather than there: by then the disk is already wiped and the
# system installed, and a system whose only account has no password locks you
# out.
[ -r /dev/tty ] || {
  echo "install: no terminal; passwd needs one to set the login password" >&2
  exit 1
}

# The configuration imports /etc/nixos/hardware-configuration.nix by absolute
# path, so write it before anything evaluates. disko owns fileSystems and
# swapDevices, hence --no-filesystems.
mkdir -p /etc/nixos
nixos-generate-config --no-filesystems --show-hardware-config \
  > /etc/nixos/hardware-configuration.nix

# The account the installed flake ends up owned by, read from the configuration
# so that users.primaryUser stays the single source of truth.
user=$(nix --extra-experimental-features "nix-command flakes" eval --impure --raw \
  ".#nixosConfigurations.$name.config.users.primaryUser")

# The placeholder below is substituted with the disko CLI from this flake's
# disko input. --yes-wipe-all-disks: the destroy step prompts otherwise.
@disko@ --mode destroy,format,mount --flake ".#$name" --yes-wipe-all-disks

# The configuration is imported by absolute path, so the new root needs its own
# copy for every later rebuild.
mkdir -p /mnt/etc/nixos
cp /etc/nixos/hardware-configuration.nix /mnt/etc/nixos/

# Installed from the clone itself; the copy below is for the booted system.
nixos-install --impure --no-root-passwd --flake ".#$name" "$@"

# Carry the flake (git metadata included, autowiring needs it) into the primary
# user's home, which activation above has just created. git refuses to read a
# repository owned by another user ("dubious ownership"), so hand the copy over
# inside the new root, where the account exists.
mkdir -p "/mnt/home/$user"
cp -rT . "/mnt/home/$user/nix-os-config"
# --silent: nixos-enter runs the new system's activation script on every call,
# which prints "setting up /etc..." each time; the command's own output is kept.
nixos-enter --silent --root /mnt -- chown -R "$user:users" "/home/$user/nix-os-config"

# Give the primary user a password, prompted for inside the new root so it never
# passes through this script. Root is left locked: wheel has passwordless sudo,
# so the user account is the way in.
echo
echo "install: set the login password for '$user' (root stays locked)"
nixos-enter --silent --root /mnt -- passwd "$user"
