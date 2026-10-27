# Import modules from outside this repo, found at $NIX_OS_CONFIG_EXTRA_MODULES
# when set, otherwise at ~/.config/nix-os-config/modules/
kind: let
  env = builtins.getEnv "NIX_OS_CONFIG_EXTRA_MODULES";
  user = import ./env-user.nix;
  roots =
    if env != ""
    then
      if builtins.pathExists (/. + env)
      then [env]
      else throw "NIX_OS_CONFIG_EXTRA_MODULES: ${env} does not exist"
    else map (home: "${home}/${user}/.config/nix-os-config/modules") ["/Users" "/home"];
in
  builtins.filter builtins.pathExists (map (root: /. + "${root}/${kind}") roots)
