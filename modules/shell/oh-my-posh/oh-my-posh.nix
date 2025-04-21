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
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
  programs.zsh.initContent = lib.mkAfter ''
    # Export the shell width to the environment variable
    function set_poshcontext() {
      export OH_MY_POSH_COLUMNS=$(oh-my-posh get width)
    }
  '';
}
