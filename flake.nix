{
  description = "Nix Flake for OS Configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

      home-manager = {
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      user = "dhlin";
      system = "x86_64-linux";
    in
    {
      homeConfigurations = (
        import ./nix/home.nix {
          inherit nixpkgs home-manager system user;
        }
      );
    };
}
