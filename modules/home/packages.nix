{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      git-extras
      ripgrep
      scc
      tig
      meslo-lgs-nf
    ];
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  fonts.fontconfig.enable = true;
}
