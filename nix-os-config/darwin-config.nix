{
  config,
  pkgs,
  system,
  user,
  ...
}: {
  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;
    tailscale.enable = true;
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    useDaemon = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
  };

  programs.zsh.enable = true;

  nixpkgs.hostPlatform = "${system}";

  users.users."${user}" = {
    shell = pkgs.zsh;
    home = "/Users/${user}";
  };
}
