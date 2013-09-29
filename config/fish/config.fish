
# I don't quite understand the scoping rules for -x, -Ux, -gx, etc. I should
# really read the docs on this one of these days lol. At any rate, i was
# having some trouble in tmux with my variables being exposed, and -Ux seems
# to have solved the issue.
set -Ux PATH ~/.bin ~/.n/bin $PATH
set -Ux N_PREFIX ~/.n

# This set of stty code has all been commented out due to
# the fact that stty has issues with Fish. Instead, i run
# stty in bash_profile before calling fish, which resolves
# the issue
# stty ixany
# stty ixoff -ixon
# stty -ixon; screen -e \^Ss

# Fish Greeting
function fish_greeting; cat ~/.config/fish/ascii_greeting; end
