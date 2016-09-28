#
# # Install Golang
#

set -e
echo "[golang.sh] ================== Installing"

mkdir -p /tmp/golang/linux
cd /tmp/golang/linux
curl -O https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
tar -xzf go1.5.1.linux-amd64.tar.gz
mv go /usr/local/go

# Now download the alternate systems that we want to cross compile cgo with,
# and add them to our bin. This lets us compile some system specific cgo stuff.
#
# This is really, really handy. Big thanks to the following article and the Groups
# link it cites as source:
#
# https://inconshreveable.com/04-30-2014/cross-compiling-golang-programs-with-native-libraries/

# TODO: Both darwin and windows have weird (both different) permissions.
# These should be changed to match whatever Linux uses.

# Darwin
mkdir ../darwin
cd ../darwin
curl -O https://storage.googleapis.com/golang/go1.5.1.darwin-amd64.tar.gz
tar -xzf go1.5.1.darwin-amd64.tar.gz
mv go/pkg/darwin_amd64 $GOROOT/pkg/darwin_amd64

# Windows 64 (not worrying about 32bit, atm)
mkdir ../windows
cd ../windows
curl -O https://storage.googleapis.com/golang/go1.5.1.windows-amd64.zip
unzip go1.5.1.windows-amd64.zip
mv go/pkg/windows_amd64 $GOROOT/pkg/windows_amd64
