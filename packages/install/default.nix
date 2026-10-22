# The installer run from a booted NixOS ISO, as `nix run .#install`.
# The script itself lives next door in install.sh.
#
# Autowired by nixos-unified, which calls this with `callPackage fn {}`, so
# `disko` resolves to the CLI in nixpkgs. Pass a different one explicitly to
# follow this flake's disko input instead.
{
  lib,
  writeShellScriptBin,
  disko,
}:
writeShellScriptBin "install" (
  builtins.replaceStrings ["@disko@"] [(lib.getExe disko)]
  (builtins.readFile ./install.sh)
)
