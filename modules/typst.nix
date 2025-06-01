{ pkgs, ... }:

{
  fonts.fontconfig.enable = true; # Enable Fontconfig support for fonts installed via Home Manager
  home.packages = with pkgs; [
    typst # Modern, developer-friendly typesetting system
    source-han-sans # Source Han Sans (思源黑体), a pan-CJK sans-serif font family
  ];
  programs.bash.profileExtra = ''
    export TYPST_FONT_PATHS="$HOME/.nix-profile/share/fonts" # Allow Typst to load fonts installed by Home Manager
  '';
}
