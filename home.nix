{ plug_kak }: { pkgs, ... }:
{
    # lorri works alongside direnv to avoid needing to constantly use nix-shell.
    services.lorri.enable = true;

    home.packages = with pkgs; [
      # Enable environments per directory. A companion to lorri,
      # enabled below.
      direnv
      htop
      alacritty
      tmux
      blender
      spotify
      _1password
      fzf
      ripgrep
      rustup

      # productivity / work software
      kontact
      slack
      zoom-us

      # dev software
      insomnia
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
