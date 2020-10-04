{ plug_kak }: { pkgs, ... }:
{
    home.packages = [
      pkgs.htop
      pkgs.tmux
      pkgs.spotify
      pkgs._1password
      pkgs.slack
      pkgs.blender
      pkgs.fzf
      pkgs.ripgrep
      pkgs.rustup
    ];

    home.file = {
        ".gitconfig".source = ./.gitconfig;
        ".config/kak/kakrc".source = ./.config/kak/kakrc;
        ".config/kak/cuser.kak".source = ./.config/kak/cuser.kak;
        # So far i can't get Plug to behave well with Nix.
        # The directory (plugins) isn't immutable, so in theory it should happily
        # clone into it - but i'm guessing Plug needs to mutate the /plug.kak directory
        # for some bookkeeping.
        #
        # For now i'll do it manually, but i'm guessing i can manage to let plug.kak
        # manage the entire /plugins directory as part of the file installation.
        # An after-file hook to run `kak -e plug-install` could.. in theory..
        # mutate what it wants. Though the output wouldn't be deterministic.. hmm
        # ".config/kak/plugins/plug.kak".source = plug_kak;
        ".tmux.conf".source = ./.tmux.conf;
    };
}
