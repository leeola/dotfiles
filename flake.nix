{
  description = "A very basic flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      nixpkgs-kak.url = "github:NixOS/nixpkgs/nixos-unstable";
      obsidian.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
          url = "github:nix-community/home-manager/release-21.05";
          inputs.nixpkgs.follows = "/nixpkgs";
      };
      plug_kak = {
          url = "github:andreyorst/plug.kak";
          flake = false;
      };

      # Dev oriented pinning/inputs
      # ###########################
      dev.url = "github:NixOS/nixpkgs/nixos-unstable";
      # Kakoune plugin manager. Not really useful with Nix, but
      # currently handles the integration of plugins in kak config too
      dev_kak_plug = {
          url = "github:andreyorst/plug.kak";
          flake = false;
      };
      dev_kak_fzf = {
          url = "github:andreyorst/fzf.kak";
          flake = false;
      };
      dev_kak_lsp = {
          url = "github:kak-lsp/kak-lsp";
          flake = false;
      };
      helix = {
          url = "github:leeola/helix/22.03-diag-next-err";
          inputs.nixpkgs.follows = "dev";
      };

      apps.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";
      darwin.url = "github:lnl7/nix-darwin/master";
      darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = {
      home-manager, nixpkgs, nixpkgs-kak, obsidian, plug_kak,
      darwin, nixpkgs-darwin,
      apps,
      dev, dev_kak_plug, dev_kak_fzf, dev_kak_lsp,
      helix,
      ... }:
  let
    obsidian-pkgs = import obsidian {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    };
  in {
    darwinConfigurations."mbp2017" = darwin.lib.darwinSystem
    # let
    #   dev = import input_dev {
    #     system = "x86_64-darwin";
    #   };
    # in
    {
      system = "x86_64-darwin";
    	# specialArgs = { inherit dev; };
      modules = [
          ./system/mbp2017/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lee = import ./home/mbp2017.nix {
              inherit dev_kak_plug dev_kak_fzf dev_kak_lsp;
              pkgs = import nixpkgs-darwin {
                system = "x86_64-darwin";
                config = { allowUnfree = true; };
              };
              apps = import apps {
                system = "x86_64-darwin";
                config = { allowUnfree = true; };
              };
              dev = import dev {
                system = "x86_64-darwin";
              };
              # helix = import helix {
              #   system = "x86_64-darwin";
              # };
              helix = helix;
            };
            #home-manager.extraSpecialArgs = { inherit dev; };
          }
      ];
      # inputs = { inherit nixpkgs-darwin darwin home-manager-darwin; };
    };

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
            };
            # home-manager.users.lee = import ./home.nix;
    	  }
	];
      };
    };

  };


}
