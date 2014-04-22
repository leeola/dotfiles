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

# Change `cd foo` to always check the current dir, and not current *and* home.
set -Ux CDPATH .

set -x DOCKER_HOST tcp://localhost:4243


# ## Alias: Docker Clean Containers
#
# Iterate through the docker containers and remove them.
function docker-clean-containers
  docker rm (docker ps -a -q)
end

# ## Alias: Clean noname images
#
# Iternate through all of the docker images, and any without a tag *(<none>)*
# are removed.
function docker-clean-images
  docker rmi (docker images | grep "^<none>" | awk '{print $3}')
end
