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

    claude-code
    aider-chat

    # Disk space analyzers.
    du-dust
    dua

    # CSV Data toolkit
    xan
  ];

  file = {
    ".gitconfig".source = ../git/gitconfig;
    ".gitignore_global".source = ../git/gitignore_global;
    ".config/helix/config.toml".source = ../helix/config.toml;
    ".config/helix/languages.toml".source = ../helix/languages.toml;
    ".config/fish/config.fish".source = ../fish/config.fish;
    ".config/fish/functions/nums.fish".source = ../fish/functions/nums.fish;
    ".config/fish/functions/dot.fish".source = ../fish/functions/dot.fish;
    ".config/fish/functions/bc_pipe.fish".source = ../fish/functions/bc_pipe.fish;
    ".tmux.conf".source = ../tmux/tmux.conf;
    ".config/zellij/config.kdl".source = ../zellij/config.kdl;
    ".config/starship.toml".source = ../starship/starship.toml;
    ".claude/CLAUDE.md".source = ../claude/CLAUDE.md;
  };
}
