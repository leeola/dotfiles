{ pkgs, unstable-pkgs }: { lib, ... }:
let
    term = import ../../home/term.nix { 
      inherit lib;
      pkgs = unstable-pkgs; 
    };
in
{
    home.packages =
        term.packages ++
    [
    ];

    home.file =
        term.file //
    {
    };

    home.activation = term.activation;

    home.stateVersion = "23.11";
}
