{
  nixpkgs,
  home-manager,
  system ? builtins.currentSystem,
  user ? builtins.getEnv "USER",
  ...
}: {
  extraModules ? [],
  name ? "home",
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  "${name}" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit user;};
    modules =
      [
        {
          home = {
            username = "${user}";
            homeDirectory = "/home/${user}";
          };
        }
        ./home-manager.nix
      ]
      ++ extraModules;
  };
}
