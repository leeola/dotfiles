{ pkgs, unstable-pkgs }: { ... }:
let
    term = import ../../home/term.nix { pkgs = unstable-pkgs; };
in
{
    home.packages =
        term.packages ++
    [
        # pkgs.ripgrep
        # pkgs.fzf
        # pkgs.direnv
        # pkgs.alacritty

        # dev.kakoune
        # dev.tmux
        # dev.kak-lsp
        # helix.packages.x86_64-darwin.helix

        # Can't seem to get these to work... :sus:
        # apps.blender
        # apps.discord
        # pkgs.slack
    ];

    home.file =
        term.file //
    {
        # ".config/kak/kakrc".source = ../../.config/kak/kakrc;
        # ".config/kak/cuser.kak".source = ../../.config/kak/cuser.kak;
        # ".config/fish/config.fish".source = ../../fish/config.fish;
        # ".config/fish/functions/dot.fish".source = ../../fish/functions/dot.fish;
        # ".config/fish/functions/pbp.fish".source = ../../fish/functions/pbp.fish;
        # ".config/fish/functions/pbc.fish".source = ../../fish/functions/pbc.fish;
    };
    # home.file = {
    #   ".config/nixpkgs/config.nix".source = ./nixpkgs/config.nix;
    #     ".gitconfig".source = ./.gitconfig;
    #     # # So far i can't get Plug to behave well with Nix.
    #     # # The directory (plugins) isn't immutable, so in theory it should happily
    #     # # clone into it - but i'm guessing Plug needs to mutate the /plug.kak directory
    #     # # for some bookkeeping.
    #     # #
    #     # # For now i'll do it manually, but i'm guessing i can manage to let plug.kak
    #     # # manage the entire /plugins directory as part of the file installation.
    #     # # An after-file hook to run `kak -e plug-install` could.. in theory..
    #     # # mutate what it wants. Though the output wouldn't be deterministic.. hmm
    #     # # ".config/kak/plugins/plug.kak".source = plug_kak;
    #     # ".config/fish/config.fish".source = ./fish/config.fish;
    #     # ".config/fish/functions/dot.fish".source = ./fish/functions/dot.fish;
    #     # ".config/fish/functions/pbp.fish".source = ./fish/functions/pbp.fish;
    #     # ".config/fish/functions/pbc.fish".source = ./fish/functions/pbc.fish;
    #     # ".tmux.conf".source = ./.tmux.conf;
    #     # ".config/alacritty/alacritty.yml".source = ./alacritty/alacritty.yml;
    #     # ".config/bottom/bottom.toml".source = ./bottom/bottom.toml;
    # };


    home.stateVersion = "23.11";
}
