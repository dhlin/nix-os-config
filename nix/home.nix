{
  nixpkgs,
  home-manager,
  system ? builtins.currentSystem,
  user ? builtins.getEnv "USER",
  ...
}: {
  extraHomeModules ? [],
  name ? "home",
  homeStateVersion ? "23.05",
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  "${name}" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit homeStateVersion extraHomeModules;};
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
