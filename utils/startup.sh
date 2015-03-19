#!/usr/bin/sh
#
# # Startup
#
# A simple script, mainly used to set /etc/profile up with the env
# variables set in the Dockerfile and variables we pass in via CLI
#

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
" >> /etc/profile

# Now run the sshd
/usr/sbin/sshd -D
