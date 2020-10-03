{
  description = "A very basic flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "/nixpkgs";
      };
  };

  outputs = { home-manager, nixpkgs, ... }: {

    #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    #defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    # nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
	# system = "x86_64-linux";
	# modules = [ ./nixos/configuration.nix ];
    # };
    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
    	  ./nixos/configuration.nix
    	  home-manager.nixosModules.home-manager
    	  {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lee = import ./home.nix;
    	  }
	];
      };
    };

  };


}
