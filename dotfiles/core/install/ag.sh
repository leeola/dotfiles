#
# # Install silversearcher
#
# General purpose searcher.

set -e
echo "[ag.sh] ================== Installing"

git clone https://github.com/ggreer/the_silver_searcher /tmp/ag
cd /tmp/ag
git checkout 0.20.0
./build.sh
make install
