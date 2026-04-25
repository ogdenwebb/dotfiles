{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    blender-bin.url = "github:edolstra/nix-warez?dir=blender";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    # patches
    nixpkgs-patch-gpurec-bump = {
      url = "https://github.com/NixOS/nixpkgs/pull/369574.diff";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-patcher, blender-bin, affinity-nix, millennium, ... }@inputs: {
    # nixosConfigurations.default = nixpkgs.lib.nixosSystem {
    # PATH: with nixpkgs-patcher
    nixosConfigurations.default = nixpkgs-patcher.lib.nixosSystem {
      system = "x86_64-linux";
      # specialArgs = { inherit inputs; };
      # for patcher
      specialArgs = inputs;

      modules = [
        ./configuration.nix

        ({ config, pkgs, ... }:
          let
            system = "x86_64-linux";
          in {
            nixpkgs.overlays = [
              blender-bin.overlays.default
              inputs.millennium.overlays.default
	      affinity-nix.overlays.default
            ];

            environment.systemPackages = with pkgs; [
              blender_5_0
              # affinity-v3
            ];

	    programs.gpu-screen-recorder-ui.enable = true;
          })
      ];
    };
  };
}

