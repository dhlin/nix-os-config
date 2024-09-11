{
  nixpkgs,
  home-manager,
  disko,
  system ? builtins.currentSystem,
  ...
}: {
  extraModules ? [],
  extraHomeModules ? [],
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
            home-manager.users.${user} = import ./home-config.nix;
            home-manager.extraSpecialArgs = {inherit homeStateVersion extraHomeModules;};
          }

          disko.nixosModules.disko

          {
            system.stateVersion = "${stateVersion}";
          }
        ]
        ++ extraModules;
    };
}
