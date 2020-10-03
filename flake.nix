{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, nixpkgs }: {

    #packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    #defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [ ./nixos/configuration.nix ];
    };

  };
}
