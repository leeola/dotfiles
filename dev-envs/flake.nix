{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.go =
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          buildInputs =
            with pkgs;
            [
              go
              gopls
              golangci-lint
              go-tools
              delve
              pkg-config
              gcc
              fd
            ]
            ++ lib.optionals stdenv.isDarwin [
              darwin.apple_sdk.frameworks.Security
              darwin.apple_sdk.frameworks.Foundation
            ];
          shellHook = ''
            alias ls=exa
            alias find=fd
            echo "Go development environment loaded"
            go version
          '';
        };
    });
}
