{ pkgs, lib }:
let
  devEnvs = import ./dev-envs.nix { inherit pkgs lib; };
in
{
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
    mcp-language-server

    # Disk space analyzers.
    du-dust
    dua

    # CSV Data toolkit
    xan

    # Nix
    nixfmt-rfc-style
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
    ".cargo/config.toml".source = ../cargo/config.toml;
    ".config/mcp-language-server/config.json".source = ../mcp-language-server/config.json;
  } // devEnvs.files;

  # Home-manager activation scripts run during system switch
  # lib.hm.dag provides a directed acyclic graph (DAG) for ordering activation steps
  # "writeBoundary" is a special marker that separates file writing from other activation tasks
  # Scripts run after writeBoundary ensure all home.file entries have been created first
  #
  # To view activation logs:
  # - `journalctl --user -u home-manager-activation.service`
  # - Or run activation manually to see output: `/nix/store/*-home-manager-generation/activate`
  activation.claudeMcpSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Ensure rust-lsp MCP server is configured for Claude
    # This runs on every system switch but only adds the server if missing

    # Get current MCP list and normalize whitespace for robust comparison
    current_mcp_list=$(${pkgs.claude-code}/bin/claude mcp list 2>/dev/null | tr -s ' \t\n' ' ' | tr -d '\r')
    expected_config="rust-lsp /etc/profiles/per-user/lee/bin/mcp-language-server"

    if ! echo "$current_mcp_list" | grep -Fq "$expected_config"; then
      echo "Adding rust-lsp MCP server..."
      ${pkgs.claude-code}/bin/claude mcp add \
        -s user \
        rust-lsp \
        "/etc/profiles/per-user/lee/bin/mcp-language-server" \
        -- \
        --workspace . \
        --lsp rust-analyzer \
        --config ~/.config/mcp-language-server/config.json
    fi
  '';
}
