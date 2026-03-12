{ myConfig, pkgs, ... }:

{
  programs.git = {
    enable = true;
    # We can use the unstable version of git if we want to.
    # package = pkgsUnstable.git;
    package = pkgs.git;
    signing = {
      key = myConfig.user.gpgSigningKey;
      signByDefault = true;
    };
    settings = {
      user = {
        name = myConfig.user.gitName;
        email = myConfig.user.email;
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
