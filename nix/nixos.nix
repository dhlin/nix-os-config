{
  nixpkgs,
  home-manager,
  system,
  user,
  ...
}: {
  nixos =
    nixpkgs.lib.nixosSystem
    {
      specialArgs = {inherit system user;};
      modules = [
        ./nixos-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./home-manager.nix;
        }
      ];
    };
}
