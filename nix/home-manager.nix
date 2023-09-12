{ config, pkgs, ... }:

{
  home = {
    packages = [
      # home-manager 23.05 doesn't have ripgrep config
      pkgs.ripgrep
    ];
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.05"; # Please read the comment before changing.
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      initExtra = ''
        bindkey \^U backward-kill-line
        source "$HOME"/nix-os-config/dotfiles/.p10k.zsh
      '';
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      shellAliases = {
        # docker
        de = "docker exec -it";
        dep = "de --privileged";
        di = "docker images";
        dirm = "docker image rm";
        dp = "docker ps";
        dpa = "docker ps -a";
        dr = "docker run -it --rm";
        drm = "docker rm";
        drp = "dr --privileged";

        # git
        gau = "git add -u";
        gb = "git branch";
        gca = "git commit --amend";
        gco = "git checkout";
        gcp = "git cherry-pick";
        gd = "git diff";
        gdc = "git diff --cached";
        gfo = "git fetch origin";
        gl = "git log";
        grs = "git restore --staged";
        grv = "git remote -vv";
        gp = "git pull origin $(git rev-parse --abbrev-ref HEAD)";
        gs = "git status";

        # file
        ll = "ls -laG";
        ".." = "cd ..";
        "..." = "cd ...";
      };
    };
  };
}

