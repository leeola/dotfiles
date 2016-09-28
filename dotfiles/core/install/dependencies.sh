#
# # Install Dependencies
#

set -e


# ## Install simple user dependencies
#
# Some user deps that we aren't yet compiling by hand. Note that we're
# grouping all yum dependencies here, for easy portability to other OSs.
#
# bc/zip/unzip required by fish
echo "[dependencies.sh] ================== Installing user package dependencies"
yum update -y
yum install -y \
  make tar \
  openssl \
  openssh-server \
  git \
  mercurial \
  curl \
  gcc gcc-c++ \
  bc zip unzip

# Required for apropos, which is needed for fish autocomplete
yum install -y man


# ## Install build dependencies
#
# Ie, dependencies we need for the build, but can remove
# after it's all done.
echo "[dependencies.sh] ================== Installing build package dependencies"
yum install -y \
  automake pcre-devel xz-devel ncurses-devel \
  zlib-devel openssl-devel autoconf libtool \
  cmake

