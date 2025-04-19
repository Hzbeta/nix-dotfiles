{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
    tmux.enableShellIntegration = true;
    defaultOptions = [
      "--height 50%"
      "--layout=reverse"
    ];
  };
}
