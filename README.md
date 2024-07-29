# nix-os-config

## Home standalone and Darwin
```
git clone https://github.com/dhlin/nix-os-config
cd nix-os-config
alias nix="nix --extra-experimental-features \"nix-command flakes\""
nix run
```

## NixOS
```
# boot from iso
sudo su
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB -1GiB # make the middle range as the primary part
parted /dev/sda -- mkpart primary linux-swap -1GiB 100% # make swap space at the end of this disk
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 esp
mkfs.ext4 -L nixos /dev/sda1 # check mkfs.* for any available file system 
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
swapon /dev/sda2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
sed --in-place '/system\.stateVersion = .*/a \
  environment.systemPackages = [pkgs.git];\n \
  services.openssh.enable = true;\n \
  users.users.root.initialPassword = \"root\";\n \
' /mnt/etc/nixos/configuration.nix
nixos-install --no-root-passwd
reboot

# remove iso, login as root
sudo su
git clone ~/https://github.com/dhlin/nix-os-config
cd nix-os-config
nix run --impure
passwd <user> # set new password for user

# login as user
```q