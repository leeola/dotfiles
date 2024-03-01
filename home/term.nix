{ pkgs, term-pkgs }: {
  packages = with pkgs; [
    helix
    mosh
    direnv
    ripgrep
    term-pkgs.tmux
  ];

  file = {
    ".gitconfig".source = ../.gitconfig;
    ".config/helix/config.toml".source = ../helix/config.toml;
    ".config/helix/languages.toml".source = ../helix/languages.toml;
    ".config/fish/config.fish".source = ../fish/config.fish;
    ".tmux.conf".source = ../tmux/tmux.conf;
    ".wezterm.lua".source = ../wezterm.lua;
  };
}
