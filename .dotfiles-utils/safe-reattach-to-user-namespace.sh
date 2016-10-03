#!/usr/bin/env bash
#
# # Safe reattach to user namespace
#
# This script simply checks if reattach-to-user-namespace is available,
# and if not, runs the requested input. The result of
# reattach-to-user-namespace will make the clipboard work on OSX while
# inside of tmux.
#
# The purpose of this script is to force tmux to always reattach to
# namespace, but not completely break if the command is not available or
# if tmux is running on a non-OSX platform.
#
# This script is credited to a Stack Overflow answer:
# http://superuser.com/a/638247

# If reattach-to-user-namespace is not available, just run the command.
if [ -n "$(command -v reattach-to-user-namespace)" ]; then
  reattach-to-user-namespace $@
else
  exec "$@"
fi
