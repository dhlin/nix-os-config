{
  description = "Nix Flake for OS Configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

      home-manager = {
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      user = builtins.getEnv "USER";
      system = builtins.currentSystem;
    in
    {
      homeConfigurations = (
        import ./nix/home.nix {
          inherit nixpkgs home-manager system user;
        }
      );

      darwinConfigurations = (
        import ./nix/darwin.nix {
          inherit nixpkgs home-manager nix-darwin system user;
        }
      );

      nixosConfigurations = (
        import ./nix/nixos.nix {
          user = "dhlin";
          inherit inputs nixpkgs home-manager system;
        }
      );
    };
}
