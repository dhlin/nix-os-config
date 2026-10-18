{pkgs, ...}: {
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

  networking = {
    firewall.enable = false;
    hostName = "nixos";
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
