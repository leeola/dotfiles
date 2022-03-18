{ dev, dev_kak_plug, dev_kak_fzf }: { pkgs, ...}: {
    home.packages = with pkgs; [
        kakoune
        tmux

        ripgrep
        fzf

        # slack
    ];

    home.file = {
      	# ".config/nixpkgs/config.nix".source = ./nixpkgs/config.nix;
        ".gitconfig".source = ../.gitconfig;
        ".config/kak/kakrc".source = ../.config/kak/kakrc;
        ".config/kak/cuser.kak".source = ../.config/kak/cuser.kak;
        # ".config/kak-lsp/kak-lsp.toml".source = ../kak-lsp/kak-lsp.toml;
        # # So far i can't get Plug to behave well with Nix.
        # # The directory (plugins) isn't immutable, so in theory it should happily
        # # clone into it - but i'm guessing Plug needs to mutate the /plug.kak directory
        # # for some bookkeeping.
        # #
        # # For now i'll do it manually, but i'm guessing i can manage to let plug.kak
        # # manage the entire /plugins directory as part of the file installation.
        # # An after-file hook to run `kak -e plug-install` could.. in theory..
        # # mutate what it wants. Though the output wouldn't be deterministic.. hmm
        ".config/kak/nix_plugins/plug.kak".source = dev_kak_plug;
        ".config/kak/nix_plugins/fzf.kak".source = dev_kak_fzf;
        # ".config/fish/config.fish".source = ../fish/config.fish;
        # ".config/fish/functions/dot.fish".source = ../fish/functions/dot.fish;
        # ".config/fish/functions/pbp.fish".source = ../fish/functions/pbp.fish;
        # ".config/fish/functions/pbc.fish".source = ../fish/functions/pbc.fish;
        ".tmux.conf".source = ../.tmux.conf;
        # ".config/alacritty/alacritty.yml".source = ../alacritty/alacritty.yml;
        # ".config/bottom/bottom.toml".source = ../bottom/bottom.toml;
    };
}
