#
# # Cleanup Installation
#

set -e


# ## Clean up excess build files and deps
echo "[core.sh] ================== Cleaningup build dependencies"
rm -rf /tmp && mkdir /tmp
yum remove -y \
    automake pcre-devel xz-devel ncurses-devel \
    zlib-devel openssl-devel autoconf libtool \
    cmake
yum clean all
