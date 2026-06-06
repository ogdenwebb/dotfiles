{
  description = "Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # solaar = {
    #   url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
    #   #url = "https://flakehub.com/f/Svenum/Solaar-Flake/0.1.7.tar.gz"; # uncomment line for solaar version 1.1.19
    #   #url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   };
  };

  # outputs = { nixpkgs, home-manager, solaar, ... }: {
  outputs = { nixpkgs, home-manager, ... }@inputs: {
    homeConfigurations.ogden = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };

        modules = [
          ./home.nix
        ];
      };
  };
}
