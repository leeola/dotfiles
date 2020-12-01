{ plug_kak }: { pkgs, ... }:
{
    # lorri works alongside direnv to avoid needing to constantly use nix-shell.
    services.lorri.enable = true;

    home.packages = with pkgs; [
      #
      # # utilities
      unzip
      etcher      # iso burner
      screenfetch # bizarrely named system info fetching

      # Enable environments per directory. A companion to lorri,
      # enabled below.
      direnv
      htop
      alacritty
      tmux
      blender
      spotify
      _1password
      git-lfs
      kak-lsp
      rust-analyzer
      cargo-edit
      fzf
      ripgrep
      rustup
      discord
      signal-desktop
      # Not available in my lock i think. I need to commit some changes before i screw with the lock.
      # bottom # A CLI system monitor

      #
      # # productivity / work software
      albert
      slack
      zoom-us

      #
      # # dev software
      insomnia
    ];

    home.file = {
      ".config/nixpkgs/config.nix".source = ./nixpkgs/config.nix;
        ".gitconfig".source = ./.gitconfig;
        ".config/kak/kakrc".source = ./.config/kak/kakrc;
        ".config/kak/cuser.kak".source = ./.config/kak/cuser.kak;
        ".config/kak-lsp/kak-lsp.toml".source = ./kak-lsp/kak-lsp.toml;
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
        ".config/fish/functions/pbp.fish".source = ./fish/functions/pbp.fish;
        ".config/fish/functions/pbc.fish".source = ./fish/functions/pbc.fish;
        ".tmux.conf".source = ./.tmux.conf;
        ".config/alacritty/alacritty.yml".source = ./alacritty/alacritty.yml;
        ".config/bottom/bottom.toml".source = ./bottom/bottom.toml;
    };
}
