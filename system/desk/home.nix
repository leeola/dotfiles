{
  unstable-pkgs,
  plug_kak,
  nixpkgs-kak,
  obsidian,
  nix_lsp_nil,
  nix_lsp_nixd,
  work,
  pin-vpn,
}: { pkgs, ... }:
let
    term = import ../../home/term.nix { pkgs = unstable-pkgs; };
in
{
    # lorri works alongside direnv to avoid needing to constantly use nix-shell.
    services.lorri.enable = true;

    # Toying with overlaps, i have no idea how to make this work... :sus:
    # import nixpkgs.overlays = [
    #   (self: super: {
    #     blender = super.blender.override { version = "2.91.0"; };
    #   })
    # ];

    imports = [ ];

    home.packages =
        term.packages ++
    (with pkgs; [
      #
      # # utilities
      xclip
      unzip
      screenfetch # bizarrely named system info fetching
      bc # Unix math command, useful for Kakoune.
      notify-desktop
      # note taker
      obsidian.obsidian
      htop
      alacritty
      obsidian.wezterm
      obsidian.blender_latest
      obsidian.krita
      spotify
      obsidian.kak-lsp
      obsidian.kakoune
      # nixpkgs-kak.legacyPackages.x86_64-linux.kak-lsp
      fzf
      obsidian.discord
      obsidian.signal-desktop
      obsidian.beeper
      # Not available in my lock i think. I need to commit some changes before i screw with the lock.
      # bottom # A CLI system monitor
      obsidian.fira-code
      obsidian.fontconfig
      obsidian.docker-compose
      flameshot # screenshot utility

      obsidian.squashfsTools
      vim
      nix_lsp_nil
      nix_lsp_nixd

      #
      # # productivity / work software
      albert
      obsidian.slack
      obsidian.zoom-us
      obsidian.google-chrome # web dev, ugh
      brave # debating switching to it?
      obsidian.chromium # testing wayland compat
      pin-vpn.pritunl-client

      #
      # # dev software
      insomnia
      obsidian.jetbrains.datagrip
      obsidian.jetbrains.clion
      gnuplot # a plotter, used by some benching tools.
      obsidian.hurl # Curl based test format

      # Music tooling
      obsidian.musescore
      obsidian.bitwig-studio
      #obsidian.pianoteq-standard-trial
      #pianoteq-stage-trial

      # Disabled because i'm not using a cam atm.
      # #
      # # # web cam focused packages
      # # obs-v4l2sink
      # # obs-studio
      # # linuxPackages.v4l2loopback

      # Misc
      obsidian.sweethome3d.application
      obsidian.mpv
      obsidian.vlc
      v4l-utils
    ]);

    home.file =
        term.file //
    {
      ".config/nixpkgs/config.nix".source = ../../nixpkgs/config.nix;
        ".config/kak/kakrc".source = ../../.config/kak/kakrc;
        ".config/kak/cuser.kak".source = ../../.config/kak/cuser.kak;
        ".config/kak-lsp/kak-lsp.toml".source = ../../kak-lsp/kak-lsp.toml;
        # So far i can't get Plug to behave well with Nix.
        # The directory (plugins) isn't immutable, so in theory it should happily
        # clone into it - but i'm guessing Plug needs to mutate the /plug.kak directory
        # for some bookkeeping.
        #
        # For now i'll do it manually, but i'm guessing i can manage to let plug.kak
        # manage the entire /plugins directory as part of the file installation.
        # An after-file hook to run `kak -e plug-install` could.. in theory..
        # mutate what it wants. Though the output wouldn't be deterministic.. hmm
        # ".config/kak/plugins/plug.kak".source = ../.plug_kak;
        ".config/fish/functions/dot.fish".source = ../../fish/functions/dot.fish;
        ".config/fish/functions/pbp.fish".source = ../../fish/functions/pbp.fish;
        ".config/fish/functions/pbc.fish".source = ../../fish/functions/pbc.fish;
        ".config/alacritty/alacritty.yml".source = ../../alacritty/alacritty.yml;
        ".config/bottom/bottom.toml".source = ../../bottom/bottom.toml;
    };

    home.stateVersion = "21.11";
}
