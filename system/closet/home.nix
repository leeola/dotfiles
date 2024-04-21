{ pkgs, unstable-pkgs }: { ... }:
let
    term = import ../../home/term.nix { pkgs = unstable-pkgs; };
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

    home.stateVersion = "23.11";
}
