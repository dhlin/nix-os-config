{
  nixpkgs,
  home-manager,
  nix-darwin,
  system ? builtins.currentSystem,
  user ? builtins.getEnv "USER",
  ...
}: {
  extraModules ? [],
  homeModules ? [],
  name ? "darwin",
  stateVersion ? 4,
  homeStateVersion ? "24.05",
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  "${name}" = nix-darwin.lib.darwinSystem {
    specialArgs = {inherit system user;};
    modules =
      [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = {
            imports = homeModules;
            home.stateVersion = homeStateVersion;
          };
        }

        {
          nix = {
            package = pkgs.nix;
            gc = {
              automatic = true;
              interval.Day = 7;
              options = "--delete-older-than 7d";
            };
            useDaemon = true;
            settings = {
              auto-optimise-store = true;
              experimental-features = "nix-command flakes";
            };
          };
          nixpkgs.hostPlatform = "${system}";
          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          system.stateVersion = stateVersion;
          users.users."${user}" = {
            home = "/Users/${user}";
          };
        }
      ]
      ++ extraModules;
  };
}
