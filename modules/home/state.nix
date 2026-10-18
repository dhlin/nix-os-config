# The home-manager state version, shared by every configuration that imports
# these modules. Autowired to `homeModules.state`.
#
# mkDefault so a configuration started on a different release can pin its own.
{lib, ...}: {
  home.stateVersion = lib.mkDefault "25.11";
}
