#
# ## Libsass Library
#

set -e
echo "[libsass.sh] ================== Installing"

git clone https://github.com/sass/libsass /tmp/libsass
cd /tmp/libsass
make shared
make install-shared
# On centos, it seems we are missing /usr/local/lib from ldconfig,
# so add it and run ldconfig to make libsass work.
echo "/usr/local/lib" > /etc/ld.so.conf.d/libsass.conf
ldconfig
