{
  lib,
  writeShellScriptBin,
  disko,
}:
writeShellScriptBin "install" (
  builtins.replaceStrings ["@disko@"] [(lib.getExe disko)]
  (builtins.readFile ./install.sh)
)
