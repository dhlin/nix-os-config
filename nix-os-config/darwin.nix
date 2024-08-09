{
  nixpkgs,
  home-manager,
  nix-darwin,
  system ? builtins.currentSystem,
  user ? builtins.getEnv "USER",
  ...
}: {
  extraModules ? [],
  extraHomeModules ? [],
  name ? "darwin",
  stateVersion ? 4,
  homeStateVersion ? "24.05",
}: {
  "${name}" = nix-darwin.lib.darwinSystem {
    specialArgs = {inherit system user;};
    modules =
      [
        ./darwin-config.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./home-config.nix;
          home-manager.extraSpecialArgs = {inherit homeStateVersion extraHomeModules;};
        }

        {
          system.stateVersion = stateVersion;
        }
      ]
      ++ extraModules;
  };
}
