# Follow this flake's disko input for the CLI too, so the `disko` command and
# the module declaring `disko.devices` come from one revision. Autowired to
# `overlays.disko`; applied to `pkgs` in modules/flake/toplevel.nix.
{flake, ...}: final: prev: {
  disko = flake.inputs.disko.packages.${prev.stdenv.hostPlatform.system}.disko;
}
