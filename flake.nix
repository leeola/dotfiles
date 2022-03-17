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

      nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
      darwin.url = "github:lnl7/nix-darwin/master";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
      home-manager-darwin.url = "github:nix-community/home-manager";
  };

  outputs = {
      home-manager, nixpkgs, plug_kak, nixpkgs-kak, obsidian,
      nixpkgs-darwin, darwin, home-manager-darwin,
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
            home-manager.users.lee = import ./home/mbp2017.nix;
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
