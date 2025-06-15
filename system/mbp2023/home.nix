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
        # Disabling, seems it's broke in master. It's flagged as broken.
        # unstable-pkgs.zed-editor
    ];

    home.file =
        term.file //
    {
        ".wezterm.lua".source = ../../wezterm/wezterm.lua;
    };

    home.activation = term.activation;

    home.stateVersion = "23.11";
}
