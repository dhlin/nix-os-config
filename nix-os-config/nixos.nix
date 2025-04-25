{
  nixpkgs,
  home-manager,
  system ? builtins.currentSystem,
  ...
}: {
  extraModules ? [],
  homeModules ? [],
  name ? "nixos",
  user,
  stateVersion ? "24.05",
  homeStateVersion ? "24.05",
}: {
  "${name}" =
    nixpkgs.lib.nixosSystem
    {
      specialArgs = {inherit system user;};
      modules =
        [
          ./nixos-config.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = {
              imports = homeModules;
              home.stateVersion = homeStateVersion;
            };
          }

          {
            system.stateVersion = "${stateVersion}";
          }
        ]
        ++ extraModules;
    };
}
