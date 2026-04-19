{
  description = "Home Manager configuration of hzbeta";

  inputs = {
    # Also include the unstable version of Nixpkgs for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hermesAgent.url = "github:NousResearch/hermes-agent";
    home-manager = {
      # `program.<name>.enable = true;` will use 25.05 channel
      url = "github:nix-community/home-manager/release-25.11";
      # url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      hermesAgent,
      home-manager,
      ...
    }:
    let
      # Import my configuration
      myConfig = import ./my-config.nix;
      nixpkgsConfig = import ./nixpkgs-config.nix;
      system = myConfig.system;
      allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) nixpkgsConfig.allowUnfree;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = allowUnfreePredicate;
      };
      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate = allowUnfreePredicate;
      };
    in
    {
      homeConfigurations.${myConfig.user.name} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          ./modules
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit pkgsUnstable myConfig hermesAgent nixpkgsConfig;
        };
      };
    };
}
