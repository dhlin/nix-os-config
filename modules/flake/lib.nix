# What makes this repo a wrapper around nixos-unified.
#
# A downstream flake declares a single input and gets nixpkgs, home-manager,
# nix-darwin, flake-parts and nixos-unified -- all pinned here -- along with
# this repo's shared modules:
#
#   {
#     inputs.nix-os-config.url = "github:dhlin/nix-os-config";
#     outputs = inputs: inputs.nix-os-config.lib.mkFlake {
#       inherit inputs;
#       root = ./.;
#     };
#   }
#
# Its configurations/ and modules/ are then autowired exactly as this repo's
# are, and `self.darwinModules.*` etc. from here are reachable as
# `inputs.nix-os-config.darwinModules.*`.
{inputs, ...}: let
  # This flake's own inputs, under a name the mkFlake argument cannot shadow.
  ours = inputs;

  # Everything a consumer needs in `inputs`, minus `self`: that must stay the
  # caller's own flake, or autowiring would pick up this repo's configurations.
  # This flake is passed along as `nix-os-config` so a downstream module can
  # reach back into it.
  inherited =
    removeAttrs ours ["self"]
    // {nix-os-config = ours.self;};
in {
  flake = {
    # The shared flake-parts module, for a downstream flake that drives
    # flake-parts itself instead of calling mkFlake.
    flakeModules.default = ./toplevel.nix;

    lib.mkFlake = {
      # The caller's inputs. Anything it declares itself wins over the pin here,
      # so a downstream flake can still override e.g. nixpkgs.
      inputs ? {},
      root,
      systems ? ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"],
      specialArgs ? {},
    }:
    # flake-parts directly rather than nixos-unified.lib.mkFlake: that one
    # throws unless `root` has a modules/flake directory, and a downstream flake
    # that only consumes this repo's modules has no reason to have one.
      ours.flake-parts.lib.mkFlake {
        inputs = inherited // inputs;
        inherit specialArgs;
      } {
        inherit systems;
        # Passed as a module arg, not read off `inputs.self`, which would make
        # autowiring infinitely recursive.
        _module.args = {inherit root;};
        imports =
          [./toplevel.nix]
          ++ (
            let
              dir = "${root}/modules/flake";
            in
              if builtins.pathExists dir
              then
                map (fn: "${dir}/${fn}")
                (builtins.attrNames (builtins.readDir dir))
              else []
          );
      };
  };
}
