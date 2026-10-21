{
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;
  };

  # nixos-unified does not set a platform (it only reads
  # `nixpkgs.hostPlatform.system`), and hardware-configuration.nix is generated
  # on the machine itself. mkDefault so that generated file still wins, while a
  # configuration without it — a fresh install — stays evaluable.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking = {
    firewall.enable = false;
    hostName = lib.mkDefault "nixos";
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };
    tailscale.enable = true;
  };

  time.timeZone = "America/Los_Angeles";
}
