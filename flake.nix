{
  description = "Nix Flake for OS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
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
    forAllSystems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: f nixpkgs.legacyPackages.${system});
  in rec {
    mkHomeConfigurations = nixpkgs.lib.callPackageWith inputs ./nix-os-config/home.nix {};
    mkDarwinConfigurations = nixpkgs.lib.callPackageWith inputs ./nix-os-config/darwin.nix {};
    mkNixosConfigurations = nixpkgs.lib.callPackageWith inputs ./nix-os-config/nixos.nix {};

    defaultHomeModules = [
      ./modules/home.nix
      ./modules/aliases.nix
    ];

    homeConfigurations = mkHomeConfigurations {
      homeModules = defaultHomeModules;
    };
    darwinConfigurations = mkDarwinConfigurations {
      extraModules = [
        ./modules/darwin.nix
      ];
      homeModules = defaultHomeModules;
    };
    nixosConfigurations = mkNixosConfigurations {
      user = "dhlin";
      extraModules = [
        /etc/nixos/hardware-configuration.nix
      ];
      homeModules = defaultHomeModules;
    };

    packages = forAllSystems (pkgs:
      with pkgs; {
        nix-os-config =
          writeShellScriptBin "nix-os-config"
          (''
              name="$1"
            ''
            + lib.optionalString stdenv.isLinux ''
              if ${gnugrep}/bin/grep -q "NixOS" /etc/os-release ; then
                sudo ${nixos-rebuild}/bin/nixos-rebuild switch --impure --flake .#''${name:=nixos}
              else
                ${home-manager.packages.${system}.home-manager}/bin/home-manager switch --impure --flake .#''${name:=home}
              fi
            ''
            + lib.optionalString stdenv.isDarwin ''
              sudo ${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild switch --impure --flake .#''${name:=darwin}
            '');
      });

    apps = forAllSystems (pkgs: rec {
      nix-os-config = {
        type = "app";
        program = "${self.packages.${pkgs.system}.nix-os-config}/bin/nix-os-config";
      };

      default = nix-os-config;
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
