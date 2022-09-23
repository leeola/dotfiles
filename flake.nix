{
  description = "A very basic flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
      nixpkgs-kak.url = "github:NixOS/nixpkgs/nixos-unstable";
      obsidian.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
          url = "github:nix-community/home-manager/release-21.11";
          inputs.nixpkgs.follows = "/nixpkgs";
      };
      plug_kak = {
          url = "github:andreyorst/plug.kak";
          flake = false;
      };
      # Helix editor
      helix.url = "github:leeola/helix/22.03-diag-next-err";
      helix.inputs.nixpkgs.follows = "obsidian";
  };

  outputs = { helix, home-manager, nixpkgs, plug_kak, nixpkgs-kak, obsidian, ... }:
  let
    obsidian-pkgs = import obsidian {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
      overlays = [
        (final: prev: {
          # rustPlatform.buildRustPackage rec {
          # helix = prev.helix.override prev.rustPlatform.buildRustPackage rec {
          # helixWtf = prev.helix.override import helix_flake {};
          # helixWtf = final.helix.overrideAttrs (oldAttrs: rec {
          #   pname = "helixWtf";
          #   version = "22.03";
          #   src = prev.fetchFromGitHub {
          #     owner = "helix-editor";
          #     repo = oldAttrs.pname;
          #     rev = "22.03";
          #     fetchSubmodules = true;
          #     sha256 = "sha256-anUYKgr61QQmdraSYpvFY/2sG5hkN3a2MwplNZMEyfI=";
          #   };
          #   #cargoSha256 = "sha256-/1qQF2/ylTtj6Z91XP+kIIkty65vJQ7Phcc9LZV3VoQ=";
          #   #cargoSha256 = prev.lib.fakeSha256;
          #   # cargoSha256 = "0000000000000000000000000000000000000000000000000000";
          #   # cargoSha256 = prev.lib.fakeSha256;
          #   # orig:
          #   #  cargoSha256 = "0000000000000000000000000000000000000000000000000000";
          #   #  cargoSha256 = "sha256-/EATU7HsGNB35YOBp8sofbPd1nl4d3Ggj1ay3QuHkCI=";
          #   # cargoDepsName = "helix-22.03";
          # });

          # # Don't need to override blender at the moment.
          # blender_latest = prev.blender.overrideAttrs (old: rec {
          #   pname = "blender";
          #   version = "3.2.0";
          #   src = prev.fetchurl {
          #     url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
          #     sha256 = "sha256-k78LL1urcQWxnF1lSoSi3CH3Ylhzo2Bk2Yvq5zbTYEo=";
          #   };               
          # });
        })
      ];
    };
  in {
    #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    #defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;
    #nixpkgs.x86_64-linux.obsidian = obsidian.legacyPackages.x86_64-linux.obsidian;

    #obsidian = (import obsidian {
    #  legacyPackages.config.allowUnfree = true;
    #});

    # nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
	# system = "x86_64-linux";
	# modules = [ ./nixos/configuration.nix ];
    # };
    #kak = nixpkgs-kak.packages.x86_64.kakoune;
    #ruby-1-2-3 = nixpkgs-kak.legacyPackages.x86_64.ruby;
    nixosConfigurations = {
      desk = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = { inherit nixpkgs-kak; inherit obsidian; };
	modules = [
    	  ./system/desk/configuration.nix
    	  home-manager.nixosModules.home-manager
    	  {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lee = import ./home.nix {
              plug_kak = plug_kak;
              nixpkgs-kak = nixpkgs-kak;
              obsidian = obsidian-pkgs;
              helix = helix.packages.x86_64-linux.helix;
              # helix = helix;
            };
            # home-manager.users.lee = import ./home.nix;
    	  }
	];
      };
    };

  };


}
