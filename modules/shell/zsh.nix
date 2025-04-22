{ lib, pkgs, ... }:

let
  shellCommon = import ./shell-common.nix;
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
        "mattmc3/ez-compinit" # Optimized compinit
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
    initContent = lib.mkAfter ''
      # For autosuggestions
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#757575,underline"

      # Set preview style for enhancd
      export ENHANCD_FILTER="fzf --preview '
        eza -al --tree --level 1 --group-directories-first --git-ignore --header --git --icons=auto \
        --color=always --hyperlink --no-user --no-time --no-filesize --no-permissions {}' \
        --preview-window=right,50% --height=50% --reverse --ansi"

      # Set cursor style for zsh
      echo -ne '\e[6 q' # Bar steady cursor
    '';
  };
}
