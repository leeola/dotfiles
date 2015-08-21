#
# # Install Golang
#

set -e
echo "[golang.sh] ================== Installing"

cd /tmp
curl -O https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz
tar -xzf go1.4.2.linux-amd64.tar.gz
mv go /usr/local/go