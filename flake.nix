{
  description = "A very basic flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
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

      nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
      darwin.url = "github:lnl7/nix-darwin/master";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
      home-manager-darwin.url = "github:nix-community/home-manager";
  };

  outputs = {
      home-manager, nixpkgs, nixpkgs-kak, obsidian, plug_kak,
      nixpkgs-darwin, darwin, home-manager-darwin,
      dev, dev_kak_plug, dev_kak_fzf,
      ... }:
  let
    obsidian-pkgs = import obsidian {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    };
  in {
    darwinConfigurations."mbp2017" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
          ./system/mbp2017/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # NIT: Not sure if this is the ideal way to pass in the inputs to HomeManager,
            # need to research this.
            home-manager.users.lee = import ./home/mbp2017.nix {
              inherit dev dev_kak_plug dev_kak_fzf;
            };
          }
      ];
      inputs = { inherit nixpkgs-darwin darwin home-manager-darwin; };
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
