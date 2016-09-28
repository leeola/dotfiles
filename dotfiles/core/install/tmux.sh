#
# # Install tmux
#
# First install libevent, a dep of tmux, then tmux.
#

set -e
echo "[tmux.sh] ================== Installing"

cd /tmp
curl -LO https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
tar -xvf libevent-2.0.21-stable.tar.gz
ls -la
cd libevent-2.0.21-stable
./configure --prefix=/usr --disable-static
make install
cd ..
git clone https://github.com/tmux/tmux tmux
cd tmux
git checkout 1.9a
sh autogen.sh
./configure
make && make install
# Suddenly this is causing a failure. Not sure why.. but if it's not
# needed, who cares?
# POSSIBLY DEPRECATED
#  ln -s /usr/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
