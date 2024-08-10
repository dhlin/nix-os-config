{
  nixpkgs,
  home-manager,
  system ? builtins.currentSystem,
  user ? builtins.getEnv "USER",
  ...
}: {
  extraHomeModules ? [],
  name ? "home",
  homeStateVersion ? "24.05",
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  "${name}" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit homeStateVersion extraHomeModules;};
    modules = [
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
        };

        nix = {
          package = pkgs.nix;
          gc = {
            automatic = true;
            options = "--delete-older-than 7d";
          };
          settings = {
            auto-optimise-store = true;
            experimental-features = "nix-command flakes";
          };
        };
      }
      ./home-config.nix
    ];
  };
}
