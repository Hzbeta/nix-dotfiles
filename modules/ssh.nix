{ pkgs, ...}:

{
  # Installation of ssh
  home.packages = [ pkgs.openssh ];
  programs.ssh = {
    enable = true;
  };
}