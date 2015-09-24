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
export PATH=$PATH:$GOBIN:/usr/local/go/bin
export TERM=screen-256color
export TZ="America/Los_Angeles"


# ## Install simple user dependencies
#
# Some user deps that we aren't yet compiling by hand. Note that we're
# grouping all yum dependencies here, for easy portability to other OSs.
#
# bc/zip/unzip required by fish
echo "[core.sh] ================== Installing user package dependencies"
yum update -y
yum install -y \
  make tar \
  openssl \
  openssh-server \
  git \
  mercurial \
  curl \
  gcc gcc-c++ \
  bc zip unzip


# ## Install build dependencies
#
# Ie, dependencies we need for the build, but can remove
# after it's all done.
echo "[core.sh] ================== Installing build package dependencies"
yum install -y \
  automake pcre-devel xz-devel ncurses-devel \
  zlib-devel openssl-devel autoconf libtool \
  cmake


# ## Run core installers
cd install
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


# ## Clean up excess build files and deps
echo "[core.sh] ================== Cleaningup build dependencies"
rm -rf /tmp && mkdir /tmp
yum remove -y \
    automake pcre-devel xz-devel ncurses-devel \
    zlib-devel openssl-devel autoconf libtool \
    cmake
yum clean all
