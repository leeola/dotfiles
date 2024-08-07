{ pkgs, unstable-pkgs }: { ... }:
let
    term = import ../../home/term.nix { pkgs = unstable-pkgs; };
in
{
    home.packages =
        term.packages ++
    [
        # Disabling, seems it's broke in master. It's flagged as broken.
        # unstable-pkgs.zed-editor
    ];

    home.file =
        term.file //
    {
        ".wezterm.lua".source = ../../wezterm/wezterm.lua;
    };

    home.stateVersion = "23.11";
}
