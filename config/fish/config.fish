# 
# # Fish Config
#
# My very basic Fish config. Be warned, i don't know what i am doing!
# http://i.imgur.com/FERCORl.jpg
#

# I don't quite understand the scoping rules for -x, -Ux, -gx, etc. I should
# really read the docs on this one of these days lol. At any rate, i was
# having some trouble in tmux with my variables being exposed, and -Ux seems
# to have solved the issue.
set -Ux PATH ~/.bin ~/.n/bin $PATH
set -Ux N_PREFIX ~/.n

# Fish Greeting
function fish_greeting; cat ~/.config/fish/ascii_greeting; end
