{
  nixpkgs,
  home-manager,
  nixos-wsl,
  system ? builtins.currentSystem,
  ...
}: {
  extraModules ? [],
  extraHomeModules ? [],
  name ? "nixos",
  user,
  isWSL ? false,
}: {
  "${name}" =
    nixpkgs.lib.nixosSystem
    {
      specialArgs = {inherit system user isWSL;};
      modules =
        [
          ./nixos-configuration.nix

          (
            if isWSL
            then
              nixos-wsl.nixosModules.wsl
              // {
                wsl.enable = true;
              }
            else {}
          )

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home-manager.nix;
            home-manager.extraSpecialArgs = {inherit extraHomeModules;};
          }
        ]
        ++ extraModules;
    };
}
