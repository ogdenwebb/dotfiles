{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    blender-bin.url = "github:edolstra/nix-warez?dir=blender";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  outputs = { self, nixpkgs, blender-bin, affinity-nix, millennium, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        ({ config, pkgs, ... }:
          let
            system = "x86_64-linux";
          in {
            nixpkgs.overlays = [
              blender-bin.overlays.default
              inputs.millennium.overlays.default

              # Overlay to wrap affinity v3 with zstd in PATH
	      (final: prev: {
	       affinity-v3 =
	       affinity-nix.packages.x86_64-linux.v3.overrideAttrs (old: {
			       nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ final.makeWrapper ];

			       postFixup = (old.postFixup or "") + ''
# Ensure zstd tools (unzstd) are always available to winetricks/tar
			       if [ -x "$out/bin/affinity-v3" ]; then
			       wrapProgram "$out/bin/affinity-v3" \
			       --prefix PATH : ${final.zstd}/bin
			       fi

# If it also ships winetricks as a separate entry, wrap it too (harmless if absent)
			       if [ -x "$out/bin/winetricks" ]; then
			       wrapProgram "$out/bin/winetricks" \
			       --prefix PATH : ${final.zstd}/bin
			       fi
			       '';
			       });
	       })

              
            ];

            environment.systemPackages = with pkgs; [
              # blender_4_3
              affinity-v3
            ];
          })
      ];
    };
  };
}

