# The nix-darwin state version, shared by every configuration that imports
# these modules. Autowired to `darwinModules.state`.
#
# mkDefault so a machine first built on a different release can pin its own.
# $ darwin-rebuild changelog
{lib, ...}: {
  system.stateVersion = lib.mkDefault 5;
}
