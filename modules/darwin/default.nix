{
  services = {
    tailscale.enable = true;
  };

  programs.zsh.enable = true;

  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
  };
}
