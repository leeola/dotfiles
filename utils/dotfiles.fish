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
      echo "
Usage:
  dotfiles <command>

Commands:
  attach            # Attach to a currently running container
  build             # Build the leeolayvar/dotfiles image
  interact          # Interact with the image
  interact-noports  # Interact with the image, without port forwarding
  run               # Run a pre-existing container
  start             # Start the container from the image

Example, Starting:

  dotfiles start
  dotfiles attach

Example, Running:

  dotfiles run
  dotfiles attach
"
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
        leeolayvar/dotfiles bash

    case "link"
      # Note that this is not smart, and assumes it's being run from ../
      echo "Removing existing and linking $PWD/dotfiles/dotfiles.fish to /usr/local/bin/dotfiles..."
      rm -f /usr/local/bin/dotfiles
      ln -s $PWD/utils/dotfiles.fish /usr/local/bin/dotfiles

    case "run"
      docker run \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --detach \
        --publish-all \
        --publish=60000-60010:60000-60010/udp \
        --publish=3000:3000 \
        --publish=3003:3003 \
        --publish=5000:5000 \
        --publish=8000:8000 \
        --publish=8080:8080 \
        --publish=8888:8888 \
        --name="dotfiles" \
        leeolayvar/dotfiles
      and echo "Dotfiles running, you can ssh/mosh into the following port:"
      and docker port dotfiles-server 22
      exit $status

    case "run-noports"
      docker run \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --name="dotfiles-server" \
        --detach \
        --publish-all \
        leeolayvar/dotfiles
        # Currently disabled, because i'm not yet sure how to
        # get the container id of the newly made nameless container
        #and echo "Dotfiles running, you can ssh/mosh into the following port:"
        #and docker port dotfiles-server 22
      exit $status

    case "start"
      docker start dotfiles

    case "*"
      fail
  end
end



# vim: set filetype=fish:
