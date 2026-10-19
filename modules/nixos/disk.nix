{
  config,
  lib,
  ...
}: {
  options.disks.main = lib.mkOption {
    type = lib.types.str;
    default = "/dev/sda";
    example = "/dev/nvme0n1";
    description = ''
      Whole-disk device that disko partitions and installs onto. Everything on
      it is destroyed when disko runs, so set it per machine after checking
      `lsblk` on the target.
    '';
  };

  config.disko.devices.disk.main = {
    device = config.disks.main;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
            extraArgs = ["-n" "boot"];
          };
        };
        swap = {
          size = "1G";
          content = {
            type = "swap";
            extraArgs = ["-L" "swap"];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            extraArgs = ["-L" "nixos"];
          };
        };
      };
    };
  };
}
