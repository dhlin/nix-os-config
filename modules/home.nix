{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      git-extras
      ripgrep
      scc
      tig
    ];
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs = {
    direnv.enable = true;

    fzf.enable = true;

    git = {
      enable = true;
      extraConfig = {
        branch = {
          autosetuprebase = "always";
        };
        pull = {
          rebase = true;
        };
        push = {
          default = "current";
        };
      };
      difftastic.enable = true;
    };

    home-manager.enable = true;

    htop.enable = true;

    tmux = {
      enable = true;
      historyLimit = 5000;
      mouse = true;
      terminal = "xterm-256color";
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      defaultKeymap = "emacs";
      initExtra = ''
        bindkey \^U backward-kill-line
      '';
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-default";
          src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/config";
          file = "p10k-lean.zsh";
        }
        {
          name = "powerlevel10k-config";
          src = ../dotfiles;
          file = ".p10k.zsh";
        }
      ];
    };
  };
}
