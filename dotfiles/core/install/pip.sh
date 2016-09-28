#
# # Install pip
#

set -e
echo "[pip.sh] ================== Installing"

cd /tmp
curl -O https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
tar -xvf setuptools-1.4.2.tar.gz
cd setuptools-1.4.2
python2.7 setup.py install
curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -
