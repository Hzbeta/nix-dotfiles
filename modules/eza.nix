{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    package = pkgs.eza;
    icons = "auto";
    colors = "auto";
    git = true;
  };
}
