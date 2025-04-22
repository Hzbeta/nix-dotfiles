{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = false;
    enableFishIntegration = false;
  };
}
