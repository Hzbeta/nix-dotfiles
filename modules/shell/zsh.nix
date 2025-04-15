{ pkgs, ... }:

let
  shellCommon = import ./shell-common.nix;
in
{
  home.packages = [ pkgs.zsh ];
  programs.zsh = {
    enable = true;
    shellAliases = shellCommon.shellAliases;
  };
}
