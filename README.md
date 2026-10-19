# nix-os-config

## Home standalone and Darwin
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
alias nix="nix --extra-experimental-features \"nix-command flakes\""
nix run
```

## NixOS

The disk layout lives in `modules/nixos/disk.nix` and is applied by
[disko](https://github.com/nix-community/disko). Check `lsblk` on the target
first and set `disks.main` in `configurations/nixos/default.nix` if the disk
is not `/dev/sda` — disko destroys everything on that device.

```
# boot from iso
sudo su
alias nix="nix --extra-experimental-features \"nix-command flakes\""
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
nix run .#install   # or: ... -- <configuration>
# ...installs, then prompts for the primary user's password
reboot

# remove iso, login as the primary user with the password you typed; root
# stays locked and wheel has passwordless sudo
cd ~/nix-os-config
nix run
```

`.#install` writes `/etc/nixos/hardware-configuration.nix`, runs the disko CLI,
copies the flake to `~/nix-os-config` in the primary user's home, runs
`nixos-install`, then runs `passwd` for that user inside the new root — so the
password is typed into `passwd` itself and never passes through the script, the
environment or shell history. It does mean the run needs someone at the
terminal to finish; the script checks for one up front rather than leaving you
with an installed system whose only account has no password. Root is left with
no password at all; `sudo` from the user needs none either.

It installs `nixosConfigurations.default`; pass another name as the first
argument (`nix run .#install -- <configuration>`), and any flags after
it go to `nixos-install`.

To only partition, format and mount under `/mnt` — when rescuing a machine, say
— run the disko CLI on its own: `nix run github:nix-community/disko -- --mode
mount --flake .#default`. Later rebuilds are just `nix run` from
`~/nix-os-config`.
