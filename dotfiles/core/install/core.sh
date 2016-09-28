#!/bin/bash
#
# # Dotfiles Core Installation
#
# This is the core installation file for leeola/dotfiles.
# It contains the bulk of the installation workload, currently intended
# for CentOS(7) machines.
#
# TODO: In all git clones/checkouts, ensure that we are checking out a
# tag/commit, to provide consistent versions.
#


# Exit on any error
set -e


# ## Configure env vars
#
# IMPORTANT: If any env vars are added, they must be added in
# ./utils/startup.fish as well, so that they are properly exposed to
# SSH'd users.
export HOME=/root
export GOPATH=/docker-shared/go
export GOBIN=/docker-shared/go/bin
export GOROOT=/usr/local/go
export GO15VENDOREXPERIMENT=1
export PATH=$PATH:$GOBIN:/usr/local/go/bin
export TERM=screen-256color
export TZ="America/Los_Angeles"

# ## Run core installers
cd install
bash dependencies.sh
bash docker.sh
bash keychain.sh
bash mosh.sh
bash ag.sh
bash pip.sh
bash tmux.sh
bash fish.sh
bash golang.sh
bash golang-tools.sh
bash node.sh
bash libsass.sh
bash nvim.sh
bash clean.sh
