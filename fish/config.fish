starship init fish | source

# A central location for any references to the dotfiles location.
set --export DOTFILES ~/dotfiles

# Not sure why, but on OSX the value is set to xterm-256. Which is then not working correctly
# with tmux, ugh.
#
# Note that `fish_256color true` wasn't seemingly doing anything.. so... /shrug
set -x TERM screen-256color

# Enables direnv on directory entry.
eval (direnv hook fish)

# Path additions
set -x PATH $PATH ~/.cargo/bin

