{
  pkgs, apps, dev, dev_kak_plug, dev_kak_fzf, dev_kak_lsp, helix
}: { ... }: {
    home.packages = [
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

    home.file = {
        # ".gitconfig".source = ../../.gitconfig;
        # ".config/kak/kakrc".source = ../../.config/kak/kakrc;
        # ".config/kak/cuser.kak".source = ../../.config/kak/cuser.kak;
        # ".config/fish/config.fish".source = ../../fish/config.fish;
        # ".config/fish/functions/dot.fish".source = ../../fish/functions/dot.fish;
        # ".config/fish/functions/pbp.fish".source = ../../fish/functions/pbp.fish;
        # ".config/fish/functions/pbc.fish".source = ../../fish/functions/pbc.fish;
        # ".tmux.conf".source = ../../.tmux.conf;
        ".claude/CLAUDE.md".source = ../../claude/CLAUDE.md;
    };
}
