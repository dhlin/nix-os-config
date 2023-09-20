{
  config,
  pkgs,
  system,
  user,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix # generated file in the system
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    extraOptions = ''
      auto-optimise-store = true
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  networking = {
    firewall.enable = false;
  };

  nixpkgs.hostPlatform = "${system}";

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
  };

  system.stateVersion = "23.05";
  time.timeZone = "America/Los_Angeles";

  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
}
