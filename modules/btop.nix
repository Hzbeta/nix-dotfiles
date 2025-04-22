{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop;
    settings = {
      theme_background = false;
      update_ms = 1000;
    };
  };
}
