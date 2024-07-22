{
  description = "Nix Flake for OS Configuration";

  inputs = {
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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    user = builtins.getEnv "USER";
    system = builtins.currentSystem;

    pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    mkHomeConfigurations = (
      import ./nix/home.nix {
        inherit nixpkgs home-manager system user;
      }
    );

    mkDarwinConfigurations = (
      import ./nix/darwin.nix {
        inherit nixpkgs home-manager nix-darwin system user;
      }
    );

    mkNixosConfigurations = (
      import ./nix/nixos.nix {
        inherit inputs nixpkgs home-manager system;
      }
    );

    homeConfigurations = mkHomeConfigurations {};
    darwinConfigurations = mkDarwinConfigurations {};
    nixosConfigurations = mkNixosConfigurations {
      user = "dhlin";
    };

    packages."${system}".nix-os-config = with pkgs;
      writeShellScriptBin "nix-os-config"
      (''
          name="$1"
        ''
        + lib.optionalString stdenv.isLinux ''
          if ${pkgs.gnugrep}/bin/grep -q "NixOS" /etc/os-release ; then
            sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --impure --flake .#''${name:=nixos}
          else
            ${home-manager.packages.${system}.home-manager}/bin/home-manager switch --impure --flake .#''${name:=home}
          fi
        ''
        + lib.optionalString stdenv.isDarwin ''
          ${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild switch --impure --flake .#''${name:=darwin}
        '');

    apps."${system}" = rec {
      nix-os-config = {
        type = "app";
        program = "${self.packages.${system}.nix-os-config}/bin/nix-os-config";
      };

      default = nix-os-config;
    };

    formatter."${system}" = nixpkgs.legacyPackages."${system}".alejandra;
  };
}
