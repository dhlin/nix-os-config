# Imports every other .nix file sitting in this same directory, so importing
# homeModules.default pulls them all in.
{
  imports = with builtins;
    map
    (fn: ./${fn})
    (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
}
