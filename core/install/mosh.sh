#
# # Install mosh
#
# TODO: REMOVE RPM DEPENDENCY
# NOTE: We're using an rpm & yum install because the source installation
# was proving very difficult.
#
# In short, protobuf would be installed but mosh's configure could never
# find protobuf. Very time consuming. The source installation code is
# below for future work.

set -e
echo "[mosh.sh] ================== Installing"

rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
yum install -y mosh

# Commented out for historical reference.
#cd /tmp
#  curl -O https://protobuf.googlecode.com/svn/rc/protobuf-2.5.0.tar.gz
#  tar xvf protobuf-2.5.0.tar.gz
##  cd protobuf-2.6.0
##  ./configure
##  make && make install
#git clone https://github.com/keithw/mosh /tmp/mosh
#  cd /tmp/mosh
##  ./autogen.sh
##  ./configure
##  make
##  make install
