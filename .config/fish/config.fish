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


set -g -x PATH ~/.bin ~/.n/bin ~/.cargo/bin $PATH
set -g -x N_PREFIX ~/.n

# Fish Greeting
#function fish_greeting
#  set -l FILES ~/.config/fish/greetings/*
#  set -l n (math 'scale=0;'(random)'%'(count $FILES)'+1')
#  echo -e (cat $FILES[$n])
#end

# Change `cd foo` to always check the current dir, and not current *and* home.
set -Ux CDPATH .



# ## Aliases

# the great dotfiles command. this uses the bare dotfiles repo with the working
# directory set to home. Meaning home *is* the repo.
alias dot '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias s stash
# vim is already symlinked to nvim, but by using an alias here,
# tmux will show nvim as the currently running process.
alias vim nvim

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

# ### Remove all docker images
function docker-rmi-all
  docker rmi (docker images | awk '{print $3}')
end


# TODO(leeola): find a way to generically define this. For the moment i'm not using
# any nix packages (i believe) so i'm going to disable this, to attempt to
# keep the fish config generic (to both user and OS).
#
# set -x PATH ~/.nix-profile/bin ~/.nix-profile/sbin $PATH
# set -x NIX_PATH nixpkgs=~/.nix-defexpr/channels/nixpkgs
# set -x SSL_CERT_FILE ~/.nix-profile/etc/ssl/certs/ca-bundle.crt
