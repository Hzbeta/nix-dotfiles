{
  lib,
  pkgs,
  myConfig,
  ...
}:

let
  yaziWrapperScript = ''
    # Shell wrapper `yy` for yazi, use `q` to quit and change directory
    # use `Q` (Shift + q) to quit and not change directory
    function yy() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"

      # Force to reset the cursor style, see https://github.com/sxyazi/yazi/discussions/1612
      printf "${myConfig.shell.cursorStyle}"
    }
  '';
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    # disable the default `yy` warper, we configure it in `yaziWrapperScript`
    enableZshIntegration = false;
    enableBashIntegration = false;
    enableNushellIntegration = false;
    enableFishIntegration = false;
  };
  home.packages = with pkgs; [
    poppler # A PDF rendering library, for yazi.
    resvg # A tiny SVG rendering library, for yazi.
  ];
  programs.zsh.initContent = lib.mkAfter yaziWrapperScript;
  programs.bash.bashrcExtra = yaziWrapperScript;
  programs.tmux.extraConfig = ''
    # Make yazi image preview work in tmux
    set -g allow-passthrough on
    set -ga update-environment TERM
    set -ga update-environment TERM_PROGRAM
  '';
}
