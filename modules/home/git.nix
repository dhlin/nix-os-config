{
  programs = {
    git = {
      enable = true;
      settings = {
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
    };

    difftastic = {
      enable = true;
      git.enable = true;
    };
  };
}
