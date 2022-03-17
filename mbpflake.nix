{
  description = "darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, darwin, nixpkgs, home-manager }: {
    darwinConfigurations."mbp" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lee = import ./home.nix;
          }
      ];
    };
  };
}
