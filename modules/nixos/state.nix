# The NixOS state version, shared by every configuration that imports these
# modules. Autowired to `nixosModules.state`.
#
# mkDefault so a machine first installed on a different release can pin its own.
{lib, ...}: {
  system.stateVersion = lib.mkDefault "25.11";
}
