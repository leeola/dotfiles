#
# # Fish Config
#
# My very basic Fish config. Be warned, i don't know what i am doing!
# http://i.imgur.com/FERCORl.jpg
#

# Keychain
function keychain
  # The default fish code in the fish shell removes
  # the following two variables even if they don't
  # exist. This causes a $status of `1` and a failure
  # to set the variable.
  #
  # By setting the variable to a fake value, we're able to
  # prevent the crappy keychain code from crashing.
  set -U SSH_AUTH_SOCK null
  set -U SSH_AGENT_PID null

  /usr/bin/keychain /root/.ssh/id_rsa
  source ~/.keychain/$HOSTNAME-fish
end

# I don't quite understand the scoping rules for -x, -Ux, -gx, etc. I should
# really read the docs on this one of these days lol. At any rate, i was
# having some trouble in tmux with my variables being exposed, and -Ux seems
# to have solved the issue.
set -Ux PATH ~/.bin ~/.n/bin $PATH
set -Ux N_PREFIX ~/.n

# Fish Greeting
function fish_greeting
  set -l FILES ~/.config/fish/greetings/*
  set -l n (math 'scale=0;'(random)'%'(count $FILES)'+1')
  echo -e (cat $FILES[$n])
end

# Change `cd foo` to always check the current dir, and not current *and* home.
set -Ux CDPATH .

set -x DOCKER_HOST tcp://192.168.59.103:2375


#
# ## Aliases
#
alias s stash
alias git hub

#
# ## Alias Functions
#

# ### Remove all Containers
# Iterate through the docker containers and remove them.
function docker-rm-all
  docker rm (docker ps -a -q)
end

# ### Remove noname images
# Iternate through all of the docker images, and any without a tag *(<none>)*
# are removed.
function docker-rmi-untagged
  docker rmi (docker images | grep "^<none>" | awk '{print $3}')
end

# ### Remove all images
function docker-rmi-all
  docker rmi (docker images | awk '{print $3}')
end


