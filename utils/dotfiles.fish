#!/usr/bin/env fish
#
# # Build
#
# A series of shortcuts for building the docker images and running
# the containers.
#

if test -z "$TAG"
  set TAG leeola/dotfiles
end

# A fail function, called to bail out of the process with an exit
# status of 1.
function fail
  echo "Error: Unaccepted input. See: dotfiles help"
  exit 1
end



# ## getPort
# Docker prints host:port, and usually we only care about the port.
# This func simply parses the port.
function getPort
  echo "$argv[1]" | awk -F: '{print $2}'
end



# ## printSshInfo
function printSshInfo
  echo "
SSH  Port:  "(getPort (docker port "$argv[1]" 22))"
Mosh Ports: "(getPort (docker port "$argv[1]" 60001))", \
"(getPort (docker port "$argv[1]" 60002))", \
"(getPort (docker port "$argv[1]" 60003))"
"
  return $status
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
  build             # Build the leeola/dotfiles image
  interact          # Interact with a noports dotfiles container
  run               # Run a dotfiles container
  run-noports       # Run a dotfiles container, with dynamic ports
  rm                # Safely stop and remove the dotfiles container
  rm-noports        # Safely stop and remove the noports container
  ssh               # SSH into the local dotfiles container
  ssh-noports       # SSH into the local noports container
  info              # Print the ssh/mosh info for the container(s)

Example, Starting:

  dotfiles start
  dotfiles attach

Example, Running:

  dotfiles run
  dotfiles attach
"
      exit 1

    case "build"
      docker build -t "$TAG" .
      echo "Built with tag '$TAG'"

    case "info"
      # Check if the container is running, before echoing
      docker port dotfiles 22 1>&- 2>&-
      and echo -n "Dotfiles Info:"
      and printSshInfo "dotfiles"
      and set -l dSuccess "true"

      docker port dotfiles-noports 22 1>&- 2>&-
      and echo "Dotfiles-noports Info:"
      and printSshInfo "dotfiles-noports"
      and set -l dnSuccess "true"

      if test -z "$dSuccess$dnSuccess"
        echo "
No dotfiles or noports container running.
"
      end

    case "interact"
      docker run --tty --interactive \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --publish-all \
        --rm \
        "$TAG" bash

    case "run"
      docker run \
        --volume=/docker-shared:/docker-shared \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --env "DOCKER_HOST=$DOCKER_HOST" \
        --hostname=(hostname) \
        --detach \
        --publish-all \
        --publish=60000-60005:60000-60005/udp \
        --publish=3000:3000 \
        --publish=3003:3003 \
        --publish=3030:3030 \
        --publish=3033:3033 \
        --publish=3333:3333 \
        --publish=5000:5000 \
        --publish=5005:5005 \
        --publish=5050:5050 \
        --publish=5055:5055 \
        --publish=5555:5555 \
        --publish=8000:8000 \
        --publish=8008:8008 \
        --publish=8080:8080 \
        --publish=8088:8088 \
        --publish=8888:8888 \
        --publish=8443:4443 \
        --name="dotfiles" \
        leeola/dotfiles
      and echo "Dotfiles running"
      and printSshInfo "dotfiles"
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
        --name="dotfiles-noports" \
        leeola/dotfiles
        and echo "Dotfiles running"
        and printSshInfo "dotfiles-noports"
      exit $status

    case "rm"
      docker stop dotfiles
      and docker rm dotfiles
      exit $status

    case "rm-noports"
      docker stop dotfiles-noports
      and docker rm dotfiles-noports
      exit $status

    case "ssh"
      # Forward stderr to supress failures
      set -l port (docker port dotfiles 22 2>/dev/null)

    case "*"
      fail
  end
end



# vim: set filetype=fish:
