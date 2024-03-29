function dot
  if not set -q DOTFILES
    echo "error: missing required DOTFILES env"
    return 1
  end

  switch $argv[1]
  case ""
    # open a subshell at the dotfiles dir for ease
    env -C $DOTFILES $SHELL
  case git kak
    # plain git and kak functionality
    env -C $DOTFILES $argv
  case st ci ls au df dc co push
    # git shortcuts
    env -C $DOTFILES git $argv
  case home
    # a shortcut to edit the home config
    env -C $DOTFILES kak home.nix
  case switch
    env -C $DOTFILES sudo nixos-rebuild switch --flake .#
  case test
    env -C $DOTFILES sudo nixos-rebuild test --flake .#
  case boot
    env -C $DOTFILES sudo nixos-rebuild boot --flake .#
  case "*"
    echo "unknown dot command: "$argv[1]
    return 1
  end
end
