{ pkgs }: {
  packages = with pkgs; [
    helix
    mosh
    direnv
    ripgrep
    tmux
    zellij
    git-lfs
    starship
  ];

  file = {
    ".gitconfig".source = ../.gitconfig;
    ".config/helix/config.toml".source = ../helix/config.toml;
    ".config/helix/languages.toml".source = ../helix/languages.toml;
    ".config/fish/config.fish".source = ../fish/config.fish;
    ".tmux.conf".source = ../tmux/tmux.conf;
    ".wezterm.lua".source = ../wezterm/wezterm.lua;
    ".config/zellij/config.kdl".source = ../zellij/config.kdl;
    ".config/starship.toml".source = ../starship/starship.toml;
  };
}
