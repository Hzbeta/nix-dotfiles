{ pkgs, ... }:

{
  programs.fd = {
    enable = true;
    package = pkgs.fd;
    hidden = true; # Search hidden files
  };
}
