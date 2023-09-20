{
  nixpkgs,
  home-manager,
  system,
  user,
  ...
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  home = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit user;};
    modules = [
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
        };
      }
      ./home-manager.nix
    ];
  };
}
