{ myConfig, pkgs, ... }:

{
  programs.git = {
    enable = true;
    # We can use the unstable version of git if we want to.
    # package = pkgsUnstable.git;
    package = pkgs.git;
    userName = myConfig.user.gitName;
    userEmail = myConfig.user.email;
    signing = {
      key = myConfig.user.gpgSigningKey;
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
