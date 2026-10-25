{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.enable = false;
    hostName = lib.mkDefault "nixos";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };
  };

  time.timeZone = "America/Los_Angeles";
}
