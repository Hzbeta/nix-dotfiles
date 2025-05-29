{ pkgs, ... }:

let
  shellCommon = import ./shell-common.nix;
in
{
  programs.bash = {
    enable = true;
    shellAliases = shellCommon.shellAliases;
    profileExtra = ''
      if [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      fi
    '';
  };
}
