{ plug_kak }: { pkgs, ... }:
{
    home.packages = [
      pkgs.htop
      pkgs.alacritty
      pkgs.tmux
      pkgs.blender
      pkgs.spotify
      pkgs._1password
      pkgs.fzf
      pkgs.ripgrep
      pkgs.rustup
      # gcc + binutils for buildessential-like behavior
      pkgs.gcc
      pkgs.binutils
      pkgs.alsaLib

      # productivity / work software
      pkgs.kontact
      pkgs.slack
      pkgs.zoom-us

      # dev software
      pkgs.insomnia
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
        ".config/fish/config.fish".source = ./fish/config.fish;
        ".config/fish/functions/dot.fish".source = ./fish/functions/dot.fish;
        ".tmux.conf".source = ./.tmux.conf;
        ".config/alacritty/alacritty.yml".source = ./alacritty/alacritty.yml;
    };
}
