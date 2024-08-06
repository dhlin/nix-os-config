{
  nixpkgs,
  home-manager,
  system ? builtins.currentSystem,
  ...
}: {
  extraModules ? [],
  extraHomeModules ? [],
  name ? "nixos",
  user,
  stateVersion ? "23.05",
  homeStateVersion ? "23.05",
}: {
  "${name}" =
    nixpkgs.lib.nixosSystem
    {
      specialArgs = {inherit system user;};
      modules =
        [
          ./nixos-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home-manager.nix;
            home-manager.extraSpecialArgs = {inherit homeStateVersion extraHomeModules;};
          }

          {
            system.stateVersion = "${stateVersion}";
          }
        ]
        ++ extraModules;
    };
}
