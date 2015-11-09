#!/usr/bin/sh
#
# # Startup
#
# Startup is the actual startup script called by Docker. We should
# use this to setup our runtime variables and files. As an example,
# /docker-shared/* should be linked to and ~/*, but this can only be
# done at runtime. That's where this script comes into play.
#

# link our docker-shared to our home
fish /root/.dotfiles/utils/link-home.fish

# Setup the profile to run with our
echo "
export HOME=$HOME
export GOPATH=$GOPATH
export GOBIN=$GOBIN
export GOROOT=$GOROOT
export PATH=$PATH
export TERM=$TERM
export DOCKER_LOG=$DOCKER_LOG
export LANG=$LANG
export LC_ALL=$LC_ALL
export DOCKER_HOST=$DOCKER_HOST
export GO15VENDOREXPERIMENT=1
" >> /etc/profile

# Now run the sshd
/usr/sbin/sshd -D
