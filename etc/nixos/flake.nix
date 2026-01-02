{
  description = "Nixos config flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos";
    # nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # nix-warez.url = "github:nix-community/nix-warez";
    blender-bin.url = "github:edolstra/nix-warez?dir=blender";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, blender-bin, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
	# Enable home-manager
        # inputs.home-manager.nixosModules.default

	({config, pkgs, ...}: {
	 nixpkgs.overlays = [ blender-bin.overlays.default ];
         # This line can either be here or in configuration.nix
	 environment.systemPackages = with pkgs; [ blender_4_3 ];
	 }) 

      ];
    };
  };
}
