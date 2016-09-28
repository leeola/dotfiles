#
# # Install N, and Node
#

set -e
echo "[node.sh] ================== Installing"

curl https://raw.githubusercontent.com/visionmedia/n/master/bin/n \
  -o /usr/bin/n
chmod +x /usr/bin/n
n stable
npm install -g gulp coffee-script webpack
