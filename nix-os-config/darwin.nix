{
  nixpkgs,
  home-manager,
  nix-darwin,
  system ? builtins.currentSystem,
  user ? (let
    sudoUser = builtins.getEnv "SUDO_USER";
  in
    if sudoUser != ""
    then sudoUser
    else builtins.getEnv "USER"),
  ...
}: {
  extraModules ? [],
  homeModules ? [],
  homeArgs ? {},
  name ? "darwin",
  stateVersion ? 5,
  homeStateVersion ? "25.05",
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
          home-manager.extraSpecialArgs = homeArgs;
        }

        {
          nix = {
            package = pkgs.nix;
            gc = {
              automatic = true;
              interval.Day = 7;
              options = "--delete-older-than 7d";
            };
            settings = {
              experimental-features = "nix-command flakes";
            };
            optimise.automatic = true;
          };
          nixpkgs.hostPlatform = "${system}";
          system.stateVersion = stateVersion;
          users.users."${user}" = {
            home = "/Users/${user}";
          };
        }
      ]
      ++ extraModules;
  };
}
