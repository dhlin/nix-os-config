# Import modules from outside this repo, found through $NIX_OS_CONFIG_EXTRA_MODULES.
kind: let
  root = builtins.getEnv "NIX_OS_CONFIG_EXTRA_MODULES";
  dir = /. + "${root}/${kind}";
in
  if root != "" && builtins.pathExists dir
  then [dir]
  else []
