#!/usr/bin/env fish
# # Install Go
#
# This is just a little script for installing a specific Go version, and adding
# any modifications to the go installation that i might want - such as adding cgo
# cross compiliation for other platforms.
#
# Note: This is designed for OSX currently, with no regard for other OSs. PRs welcome
# if desired.

set TMP_DIR /tmp/install-go

# I could pull the goroot from environment variables, but
# seeing as i'm removing it, i want these variables to be
# hand coded so this script never does something unexpected.
set INSTALL_TO /usr/local/go

function fail
  echo "Failed to: $argv"
  exit 1
end


if test (count $argv) -ne "1"
  echo "Incorrect usage, missing version to install. Example:
    install-go.fish 1.7.1
"
  fail "usage"
end

# Fish starts at index 1. I always forget that.
set VERSION $argv[1]

# Run sudo right away, so i don't have to be present later.
sudo echo > /dev/null
or fail "sudo test"

echo "Installing Go $VERSION"
if which go
  echo "Starting with version:"
  go version
  or fail "checking go version"
end


# These two variable tests might be extreme, but since i'm removing the dir,
# i'm going to try and do everything i can to ensure i remove the proper dir.. haha.
if test "$INSTALL_TO" != "$GOROOT"
  echo "The GOROOT and handwritten INSTALL_TO variables must match"
  echo "GOROOT: $GOROOT, INSTALL_TO: $INSTALL_TO"
  fail "validate INSTALL_TO path"
end
if test -e "GOROOT"
  echo "For safety reasons GOROOT cannot be empty."
  fail "validate GOROOT"
end

mkdir -p $TMP_DIR
or fail "make temp dir"

pushd $TMP_DIR
or fail "push into temp dir"

curl -O --fail "https://storage.googleapis.com/golang/go$VERSION.darwin-amd64.tar.gz"
or fail "download golang"

tar -xvzf "go$VERSION.darwin-amd64.tar.gz"
or fail "extracting go"

rm -rf "go$VERSION.darwin-amd64.tar.gz"
or fail "removing go archive"

sudo rm -rf $INSTALL_TO
or fail "removing $INSTALL_TO"

sudo mv go $INSTALL_TO

echo "

Go installed."
go version

popd
