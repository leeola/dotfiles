#
# # NeoVim
#

set -e
echo "[libsass.sh] ================== Installing"

# Checking out the commit i've used for ages:
# 61c98e7e35b18081a8f723406d5ed5f241ddbc96
git clone https://github.com/neovim/neovim /tmp/neovim
cd /tmp/neovim
git checkout 61c98e7e35b18081a8f723406d5ed5f241ddbc96
make install
