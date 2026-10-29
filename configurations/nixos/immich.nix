# An Immich photo server: everything in ./default.nix (disk layout, user,
# shared defaults, home-manager) plus the immich module. Install it with
# `nix run --impure .#install -- immich`.
{flake, ...}: let
  inherit (flake.inputs) self;
in {
  imports = [
    ./default.nix
    self.nixosModules.immich
  ];
}
