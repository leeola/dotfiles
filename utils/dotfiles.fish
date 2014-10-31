#!/usr/bin/env fish
#
# # Build
#
# A series of shortcuts for building the docker images and running
# the containers.
#

# A fail function, called to bail out of the process with an exit
# status of 1.
function fail
  echo "Error: Unaccepted input. See: dotfiles help"
  exit 1
end






# ## Build
function build
end


# ## Top Level Command Parse
#
# Use a switch to figure out which command to call.
if test (count $argv) -lt 1
  fail
else
  switch $argv[1]
    case "help"
      echo "No help at the moment"
      exit 1

    case "attach"
      docker attach dotfiles

    case "build"
      docker build -t leeolayvar/dotfiles .

    case "interact"
      docker run --tty --interactive \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --publish=3000:3000 \
        --publish=3003:3003 \
        --publish=5000:5000 \
        --publish=8000:8000 \
        --publish=8080:8080 \
        --publish=8888:8888 \
        --rm \
        leeolayvar/dotfiles

    case "interact-noports"
      docker run --tty --interactive \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --rm \
        leeolayvar/dotfiles

    case "link"
      # Note that this is not smart, and assumes it's being run from ../
      echo "Removing existing and linking $PWD/dotfiles/dotfiles.fish to /usr/local/bin/dotfiles..."
      rm -f /usr/local/bin/dotfiles
      ln -s $PWD/utils/dotfiles.fish /usr/local/bin/dotfiles

    case "run"
      docker run --tty --interactive \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --publish=3000:3000 \
        --publish=3003:3003 \
        --publish=5000:5000 \
        --publish=8000:8000 \
        --publish=8080:8080 \
        --publish=8888:8888 \
        --detach \
        --name="dotfiles" \
        leeolayvar/dotfiles

    case "start"
      docker start dotfiles

    case "*"
      fail
  end
end



# vim: set filetype=fish:
