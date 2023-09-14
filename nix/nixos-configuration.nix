{ config, pkgs, system, user, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_15;
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
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  networking = {
    firewall.enable = false;
    useDHCP = false;
    interfaces.ens0.useDHCP = true;
  };

  nixpkgs.hostPlatform = "${system}";

  programs.zsh.enable = true;

  services = {
    openssh =
      {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    # tailscale.enable = true;
  };

  system.stateVersion = "23.05";
  time.timeZone = "America/Los_Angeles";

  users.users."${user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
}
