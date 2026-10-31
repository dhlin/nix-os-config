{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      btop
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
