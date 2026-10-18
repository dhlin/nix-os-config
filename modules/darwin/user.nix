# The primary user of a darwin machine, derived from the environment.
# Autowired to `darwinModules.user`.
#
# The username defaults to $SUDO_USER (the invoking user when running under
# sudo, as darwin-rebuild does), falling back to $USER. That default is what
# makes evaluation impure -- but only when it is used: a configuration that
# sets `system.primaryUser` itself outranks the mkDefault, so the getEnv calls
# are never forced and the configuration evaluates without --impure.
#
# Consumers that need the name -- to key `home-manager.users`, say -- read it
# back from `config.system.primaryUser` instead of recomputing it.
{
  config,
  lib,
  pkgs,
  ...
}: let
  envUser = import ../../lib/env-user.nix;
  inherit (config.system) primaryUser;
in {
  system.primaryUser = lib.mkDefault envUser;

  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    # mkDefault so a machine can keep whatever login shell it already has.
    shell = lib.mkDefault pkgs.zsh;
  };

  nix.settings.trusted-users = ["root" primaryUser];
}
