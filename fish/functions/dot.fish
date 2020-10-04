function dot
  switch $argv[1]
  case git kak
    # plain git and kak functionality
    env -C ~/projects/dotfiles $argv
  case st ci ls au
    # git shortcuts
    env -C ~/projects/dotfiles git $argv
  case home
    # a shortcut to edit the home config
    env -C ~/projects/dotfiles kak home.nix
  case switch
    env -C ~/projects/dotfiles sudo nixos-rebuild switch --flake .#pc
  case "*"
    echo "unknown dot command: "$argv[1]
    return 1
  end
end
