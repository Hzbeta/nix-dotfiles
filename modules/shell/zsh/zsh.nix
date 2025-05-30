{
  lib,
  pkgs,
  myConfig,
  ...
}:

let
  shellCommon = import ./../shell-common.nix;
in
{
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    shellAliases = shellCommon.shellAliases;
    # Disable nix's built-in features:
    # - autosuggestions
    # - completion
    # - syntax highlighting
    # to manage them via antidote
    autosuggestion.enable = false;
    enableCompletion = false;
    syntaxHighlighting.enable = false;
    historySubstringSearch.enable = true;
    history.share = true;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "getantidote/use-omz" # Required for oh-my-zsh plugins
        "zsh-users/zsh-completions" # Additional completions, must before compinit
        # "mattmc3/ez-compinit" # Optimized compinit, should not be used with `getantidote/use-omz`
        "Aloxaf/fzf-tab" # Enhanced tab completion with fzf, must after compinit
        "zsh-users/zsh-autosuggestions" # Fish-like autosuggestions, must after fzf-tab
        "zdharma-continuum/fast-syntax-highlighting" # Syntax highlighting, must after fzf-tab
        "b4b4r07/enhancd" # Enhanced cd command
        "joshskidmore/zsh-fzf-history-search" # Ctrl-r history search with fzf
        "ohmyzsh/ohmyzsh path:lib" # oh-my-zsh core library
        "ohmyzsh/ohmyzsh path:plugins/extract" # Universal archive extractor (alias: x)
        "ohmyzsh/ohmyzsh path:plugins/sudo" # Double ESC to prefix sudo
        "ohmyzsh/ohmyzsh path:plugins/command-not-found" # Package suggestions
      ];
    };
    initContent = lib.mkAfter (
      ''
        # Set cursor style
        printf "${myConfig.shell.cursorStyle}"
      ''
      + builtins.readFile ./dot_zshrc_last.sh
    );
  };
}
