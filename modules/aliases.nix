{
  home.shellAliases = {
    # file
    ll = "ls -laG";
    ".." = "cd ..";
    "..." = "cd ../..";

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
  };
}
