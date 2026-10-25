# Login name of the user a configuration is being activated for: $SUDO_USER
# when running under sudo (as darwin-rebuild and nixos-rebuild do), otherwise
# $USER.
#
# Evaluating this is what makes a configuration impure, so it is only ever used
# as a mkDefault -- a configuration that sets the name itself outranks that
# default and the getEnv calls are never forced.
let
  sudoUser = builtins.getEnv "SUDO_USER";
in
  if sudoUser != ""
  then sudoUser
  else builtins.getEnv "USER"
