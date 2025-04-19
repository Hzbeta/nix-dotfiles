{ pkgs, ... }:

let
  shellCommon = import ./shell-common.nix;
in
{
  programs.bash = {
    enable = true;
    shellAliases = shellCommon.shellAliases;
  };
}
