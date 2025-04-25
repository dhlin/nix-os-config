{
  pkgs,
  user,
  ...
}: {
  services = {
    tailscale.enable = true;
  };

  programs.zsh.enable = true;

  users.users."${user}" = {
    shell = pkgs.zsh;
  };
}
