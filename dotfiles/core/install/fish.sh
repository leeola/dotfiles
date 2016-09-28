#
# # Install Fish
#

set -e
echo "[fish.sh] ================== Installing"

cd /tmp
git clone https://github.com/fish-shell/fish-shell
cd fish-shell
git checkout 2.1.1
autoconf
./configure
make
make install
