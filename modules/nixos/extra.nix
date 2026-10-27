{config, ...}: let
  extra = import ../../lib/extra-modules.nix;
in {
  imports = extra "nixos";

  home-manager.users.${config.nix-os-config.primaryUser}.imports = extra "home";
}
