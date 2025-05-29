{
  shellAliases = {
    nfu = "nix flake update --flake ~/.config/home-manager";
    hms = "home-manager switch --flake ~/.config/home-manager";
    hmsb = "home-manager switch --flake ~/.config/home-manager -b home-manager-backup";
    hmsp = "git -C ~/.config/home-manager pull && hms";
  };
}
