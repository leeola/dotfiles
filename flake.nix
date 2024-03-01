{
  description = "A very basic flake";

  inputs = {
      system-input.url = "github:NixOS/nixpkgs/nixos-23.11";
      adev.url = "github:NixOS/nixpkgs/nixos-23.05";
      slow-input.url = "github:NixOS/nixpkgs/nixos-23.05";
      work-input.url = "github:NixOS/nixpkgs/nixos-unstable";
      term-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      # Hopefully temporary pin because it broke when i updated obsidian -_-
      pin-vpn-input.url = "github:NixOS/nixpkgs/fb942492b7accdee4e6d17f5447091c65897dde4";

      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
      nixpkgs-kak.url = "github:NixOS/nixpkgs/nixos-unstable";
      obsidian.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
          url = "github:nix-community/home-manager/release-23.11";
          inputs.nixpkgs.follows = "/nixpkgs";
      };
      plug_kak = {
          url = "github:andreyorst/plug.kak";
          flake = false;
      };
      # Helix editor
      # # helix.url = "github:leeola/helix/22.03-diag-next-err";
      # helix.url = "github:leeola/helix/22.12-ctrlj-master";
      # # helix.url = "github:helix-editor/helix/22.12";
      # helix.inputs.nixpkgs.follows = "obsidian";
      # Nix language LSP
      nix_lsp_nil = {
        url = "github:oxalica/nil";
        inputs.nixpkgs.follows = "obsidian";
      };
      nix_lsp_nixd = {
        url = "github:nix-community/nixd";
        inputs.nixpkgs.follows = "obsidian";
      };

      darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
      darwin.url = "github:lnl7/nix-darwin/master";
      darwin.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = {
    system-input,
    slow-input,
    work-input,
    pin-vpn-input,
    term-pkgs,

    home-manager, nixpkgs, plug_kak, nixpkgs-kak, obsidian, nix_lsp_nil, nix_lsp_nixd,
    
    darwin, darwin-nixpkgs,

     ...
  }:
  let
    obsidian-pkgs = import obsidian {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
      overlays = [
        (final: prev: rec {
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
            
          freetype_brotli = prev.freetype.overrideAttrs (old: rec {
            nativeBuildInputs = old.nativeBuildInputs ++ [ prev.brotli ];
          });
          
          blender_latest = (prev.blender.overrideAttrs (old: rec {
            pname = "blender";
            version = "4.0.1";
            src = prev.fetchurl {
              url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
              sha256 = "sha256-/jLU0noX5RxhQ+26G16nGFylm65Lzfm9s11oCWCC43Q=";
            };               
            # Disabling these, as they broke when i updated updated my lockfile.
            # nativeBuildInputs = old.nativeBuildInputs ++ [ prev.libepoxy freetype_brotli ];
          })).override {
            cudaSupport = true;
          };

          obsidian_latest = prev.obsidian.overrideAttrs (old: rec {
            version = "1.0.0";
            filename = if prev.stdenv.isDarwin then "Obsidian-${version}-universal.dmg" else "obsidian-${version}.tar.gz";
            src = prev.fetchurl {
              url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${filename}";
              sha256 = if prev.stdenv.isDarwin then "1q9almr8k1i2wzksd09libgnvypj5k9j15y6cxg4rgnw32fa152n" else "sha256-H1Cl9SBz/mwN8gezFkcV4KxI7+xVjQV2AtyLKyjVpI8=";
            };
          });
        })
      ];
    };
    work = import work-input {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    };
    system = import system-input {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    };
    pin-vpn = import pin-vpn-input {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
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
    nixosConfigurations.desk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        # NIT: I think i can remove these..?
        inherit nixpkgs-kak; inherit obsidian;

        system = system;
      };
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
                  work = work;
                  pin-vpn = pin-vpn;
                  nix_lsp_nil = nix_lsp_nil.packages.x86_64-linux.nil;
                  nix_lsp_nixd = nix_lsp_nixd.packages.x86_64-linux.nixd;
                };
        	  }
      ];
    };
    nixosConfigurations.closet = system-input.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
    	  ./system/closet/configuration.nix
      ];
    };
    # darwinConfigurations."mbp2017" = darwin.lib.darwinSystem {
    #   system = "x86_64-darwin";
    #   # inputs = { inherit nixpkgs-darwin darwin home-manager-darwin; };
    #   modules = [
    #     ./system/mbp2017/darwin-configuration.nix
    #     home-manager.darwinModules.home-manager {
    #       home-manager.useGlobalPkgs = true;
    #       home-manager.useUserPackages = true;
    #       home-manager.users.lee = import ./system/mbp2017/home.nix {
    #         # inherit dev_kak_plug dev_kak_fzf dev_kak_lsp;
    #         #home-manager.extraSpecialArgs = { inherit dev; };
    #         pkgs = import nixpkgs-darwin {
    #           system = "x86_64-darwin";
    #           config = { allowUnfree = true; };
    #         };
    #         apps = import apps {
    #           system = "x86_64-darwin";
    #           config = { allowUnfree = true; };
    #         };
    #         dev = import dev {
    #           system = "x86_64-darwin";
    #         };
    #         helix = helix;
    #         };
    #       }
    #   ];
    # };
    darwinConfigurations."mbp2023" = darwin.lib.darwinSystem {
      # system = "aarch64-darwin";
      # inputs = { inherit nixpkgs-darwin darwin home-manager-darwin; };
      modules = [
        ./system/mbp2023/darwin-configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lee = import ./system/mbp2023/home.nix {
            # inherit dev_kak_plug dev_kak_fzf dev_kak_lsp;
            #home-manager.extraSpecialArgs = { inherit dev; };
            pkgs = import darwin-nixpkgs {
              system = "aarch64-darwin";
              config = { allowUnfree = true; };
            };
            term-pkgs = import term-pkgs {
              system = "aarch64-darwin";
            };
            # apps = import apps {
            #   system = "aarch64-darwin";
            #   config = { allowUnfree = true; };
            # };
            # dev = import dev {
            #   system = "aarch64-darwin";
            # };
            # helix = helix;
            };
          }
      ];
    };
  };
}
