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
    jujutsu
    node2nix
  ];

  file = {
    ".gitconfig".source = ../git/gitconfig;
    ".config/helix/config.toml".source = ../helix/config.toml;
    ".config/helix/languages.toml".source = ../helix/languages.toml;
    ".config/fish/config.fish".source = ../fish/config.fish;
    ".config/fish/functions/nums.fish".source = ../fish/functions/nums.fish;
    ".tmux.conf".source = ../tmux/tmux.conf;
    ".config/zellij/config.kdl".source = ../zellij/config.kdl;
    ".config/starship.toml".source = ../starship/starship.toml;
  };
}
