{ pkgs, ... }:

let
  shellCommon = import ./shell-common.nix;
in
{
  home.packages = [ pkgs.bash ];
  programs.bash = {
    enable = true;
    shellAliases = shellCommon.shellAliases;
  };
}
