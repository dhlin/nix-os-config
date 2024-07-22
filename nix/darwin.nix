{
  nixpkgs,
  home-manager,
  nix-darwin,
  system,
  user,
  ...
}: {mod ? []}: {
  darwin = nix-darwin.lib.darwinSystem {
    specialArgs = {inherit system user;};
    modules =
      [
        ./darwin-configuration.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./home-manager.nix;
        }
      ]
      ++ mod;
  };
}
