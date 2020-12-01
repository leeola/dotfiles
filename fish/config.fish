
# A central location for any references to the dotfiles location.
set --export DOTFILES ~/dotfiles

# Enables direnv on directory entry.
eval (direnv hook fish)

# Path additions
set -x PATH $PATH ~/.cargo/bin

