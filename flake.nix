{
  description = "Home Manager configuration of hzbeta";

  inputs = {
    # Also include the unstable version of Nixpkgs for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      # `program.<name>.enable = true;` will use 24.11 channel
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
      # Import my configuration
      myConfig = import ./my-config.nix;
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
          inherit pkgsUnstable myConfig;
        };
      };
    };
}
