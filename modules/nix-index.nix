{ pkgs, ... }:

{
  programs.nix-index = {
    enable = true;
    package = pkgs.nix-index;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false; # I don't use fish shell yet
  };
}
