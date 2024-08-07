{ pkgs, unstable-pkgs }: { ... }:
let
    term = import ../../home/term.nix { pkgs = unstable-pkgs; };
in
{
    home.packages =
        term.packages ++
    [
        unstable-pkgs.zed-editor
    ];

    home.file =
        term.file //
    {
        ".wezterm.lua".source = ../../wezterm/wezterm.lua;
    };

    home.stateVersion = "23.11";
}
