{
  description = "A very basic flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "/nixpkgs";
      };
      plug_kak = {
          url = "github:robertmeta/plug.kak";
          flake = false;
      };
  };

  outputs = { home-manager, nixpkgs, plug_kak, ... }: {

    #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    #defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    # nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
	# system = "x86_64-linux";
	# modules = [ ./nixos/configuration.nix ];
    # };
    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
        # inherit  gii
	system = "x86_64-linux";
	modules = [
    	  ./nixos/configuration.nix
    	  home-manager.nixosModules.home-manager
    	  {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lee = import ./home.nix { plug_kak = plug_kak; };
            # home-manager.users.lee = import ./home.nix;
    	  }
	];
      };
    };

  };


}
