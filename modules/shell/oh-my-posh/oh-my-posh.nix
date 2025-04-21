{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

{
  programs.oh-my-posh = {
    enable = true;
    # package = pkgsUnstable.oh-my-posh;
    package = pkgs.oh-my-posh;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;
    enableFishIntegration = false;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
  programs.zsh.initContent = lib.mkAfter ''
    # Export the shell width to the environment variable
    function set_poshcontext() {
      export OH_MY_POSH_COLUMNS=$(oh-my-posh get width)
    }
  '';
  # Bash not supported for mkAfter yet
  # So we can not use dynamic width for `path`
}
