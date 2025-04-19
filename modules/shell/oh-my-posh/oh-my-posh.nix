{ pkgs, ... }:

{
  home.packages = [ pkgs.oh-my-posh ];
  programs.oh-my-posh = {
    enable = true;
    package = pkgs.oh-my-posh;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
}
