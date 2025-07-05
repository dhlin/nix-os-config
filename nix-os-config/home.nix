{
  nixpkgs,
  home-manager,
  system ? builtins.currentSystem,
  user ? builtins.getEnv "USER",
  ...
}: {
  homeModules ? [],
  homeArgs ? {},
  name ? "home",
  homeStateVersion ? "25.05",
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  "${name}" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = homeArgs;
    modules =
      [
        {
          home = {
            username = "${user}";
            homeDirectory = "/home/${user}";
            stateVersion = homeStateVersion;
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
      ]
      ++ homeModules;
  };
}
